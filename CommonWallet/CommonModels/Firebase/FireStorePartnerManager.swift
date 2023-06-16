//
//  FireStoreConnectPatnerManager.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

struct FireStorePartnerManager: FireStorePartnerManaging {

    private let db = Firestore.firestore()
    private var userDefaultManager = UserDefaultsManager()
    private var storageManager = StorageManager()

    /**
     FireStorageでパートナーとの接続登録
     - Description
     - 自分と相手のFireStoreの "partnerUserId" にお互いのUserIDを登録する
     - 登録は並列で非同期処理を行う
     - parameter myUserId: 引数１詳細
     - parameter partnerShareNumber: 引数２詳細
     - Returns: FireStoreで取得したPartner
     */
    func connectPartner(myUserId: String, partnerShareNumber: String) async throws -> Partner {
        // partnerShareNumberからpartner情報を取得
        let snapShots = try await db.collection("Users")
            .whereField("shareNumber", isEqualTo: partnerShareNumber)
            .getDocuments()
        guard let data = snapShots.documents.first?.data(),
              let partnerUserId = data["id"] as? String,
              let partnerIconPath = data["iconPath"] as? String,
              let partnerName = data["name"] as? String else {
            throw InvalidValueError.unexpectedNullValue
        }

        // 非同期1: 自分のPartnerIdに相手のUserIdを入れる
        async let _ = db.collection("Users")
            .document(myUserId)
            .setData([
                "partnerUserId": partnerUserId,
            ], merge: true)

        // 非同期2: 相手のPartnerIdに自分のUserIdを入れる
        async let _ = db.collection("Users")
            .document(partnerUserId)
            .setData([
                "partnerUserId": myUserId,
            ], merge: true)

        // 非同期3: PartnerIconDataを取得
        async let partnerIconData = try await storageManager.download(path: partnerIconPath)

        let partner = try await Partner(userId: partnerUserId, userName: partnerName, shareNumber: partnerShareNumber, iconPath: partnerIconPath, iconData: partnerIconData)
        return partner
    }

    /**
     FireStorageからパートナーを削除
     - Description
        - FireStoreのUsersコレクションにて自分とパートナーの "partnerUserId" を空にする
        - 並列で非同期処理を行う
     - parameter myUserId: 自身のユーザーID
     - parameter partnerUserId: パートナーのユーザーID
    */
    func deletePartner(myUserId: String, partnerUserId: String) async throws {
        async let _ = db.collection("Users")
            .document(myUserId)
            .setData([
                "partnerUserId": FieldValue.delete(),
            ], merge: true)

        async let _ = db.collection("Users")
            .document(partnerUserId)
            .setData([
                "partnerUserId": FieldValue.delete(),
            ], merge: true)

    }

    /*
     パートナーの情報を取得し、自分のUserdefaultsを更新する
     */
    func fetchPartnerInfo(completion: @escaping(User?, Error?) -> Void) {
        guard let myUserId = Auth.auth().currentUser?.uid else {
            completion(nil, AuthError.emptyUserId)
            return
        }

        guard let myUserInfo = userDefaultManager.getUser() else {
            completion(nil, UserDefaultsError.emptySomeValue)
            return
        }

        // 自分のpartnerが存在しているかチェック
        db.collection("Users").document(myUserId)
            .addSnapshotListener { querySnapshot, error in

                if let error = error {
                    print("FireStore PartnerInfo Fetch Error")
                    completion(nil, error)
                }
                guard let data = querySnapshot?.data(),
                      let partnerUserId = data["partnerUserId"] as? String else {
                    completion(nil, InvalidValueError.unexpectedNullValue)
                    return
                }

                // パートナーの名前の取得
                self.db.collection("Users").document(partnerUserId)
                    .addSnapshotListener { querySnapshot, error in

                        if let error = error {
                            print("FireStore PartnerInfo Fetch Error")
                            completion(nil, error)
                        }

                        guard let data = querySnapshot?.data(),
                              let partnerName = data["name"] as? String,
                              let partnerIconPath = data["iconPath"] as? String,
                              let partnerShareNumber = data["shareNumber"] as? String else {
                            completion(nil, InvalidValueError.unexpectedNullValue)
                            return
                        }

                        // パートナーのIconPathが変更されていた場合、
                        // 自分のuserdefaultsに保存されてるpartnerIconDataを更新
                        if let iconPath = self.userDefaultManager.getPartnerIconImagePath(),
                           let _ = self.userDefaultManager.getPartnerIconImageData() {

                            if partnerIconPath != iconPath {
                                // UserDefaultにセットする

                            }

                        }

                        let user = User(name: myUserInfo.name, email: myUserInfo.email, shareNumber: myUserInfo.shareNumber, iconPath: myUserInfo.iconPath, createdAt: myUserInfo.createdAt, partnerUserId: partnerUserId, partnerName: partnerName, partnerShareNumber: partnerShareNumber)

                        completion(user, nil)
                    } // ネストのdbここまで
            }// はじめのdbここまで
    }
}

