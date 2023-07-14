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
        guard let myShareNumber = userDefaultManager.getUser()?.shareNumber else {
            throw UserDefaultsError.emptySomeValue
        }
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
                "partnerShareNumber": partnerShareNumber,
            ], merge: true)

        // 非同期2: 相手のPartnerIdに自分のUserIdを入れる
        async let _ = db.collection("Users")
            .document(partnerUserId)
            .setData([
                "partnerUserId": myUserId,
                "partnerShareNumber": myShareNumber,
            ], merge: true)

        // 非同期3: PartnerIconDataを取得
        async let partnerIconData = try await storageManager.download(path: partnerIconPath)

        let partner = try await Partner(
            userId: partnerUserId,
            userName: partnerName,
            modifiedName: partnerName,
            shareNumber: partnerShareNumber,
            iconPath: partnerIconPath,
            iconData: partnerIconData
        )
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
                "partnerShareNumber": FieldValue.delete(),
            ], merge: true)

        async let _ = db.collection("Users")
            .document(partnerUserId)
            .setData([
                "partnerUserId": FieldValue.delete(),
                "partnerShareNumber": FieldValue.delete(),
            ], merge: true)
    }

    /**
     FireStorageからパートナーの情報をリアルタイム取得
     - Description
     - parameter myUserId: 自身のユーザーID
     */
    func realtimeFetchPartnerInfo(partnerUserId: String, completion: @escaping(Partner?, Error?) -> Void) {

        // partnerUserIdからpartnerのデータを取得
        db.collection("Users").document(partnerUserId)
            .addSnapshotListener { querySnapshot, error in

                if let error = error {
                    print("FireStore PartnerInfo Fetch Error")
                    completion(nil, error)
                }

                guard let data = querySnapshot?.data(),
                      let partnerUserName = data["name"] as? String,
                      let partnerIconPath = data["iconPath"] as? String,
                      let partnerShareNumber = data["shareNumber"] as? String else {
                    completion(nil, InvalidValueError.unexpectedNullValue)
                    return
                }

                // パートナーのIconDataを取得する
                self.storageManager.download(path: partnerIconPath, completion: { data, error in

                    if let error = error {
                        completion(nil, error)
                    }

                    guard let data = data else {
                        completion(nil, NSError())
                        return
                    }
                    let modifiedName = userDefaultManager.getPartnerModifiedName()
                    // return処理
                    let partner = Partner(
                        userId: partnerUserId,
                        userName: partnerUserName,
                        modifiedName: modifiedName,
                        shareNumber: partnerShareNumber,
                        iconPath: partnerIconPath,
                        iconData: data
                    )
                    completion(partner, nil)
                })
            }
    }
}

