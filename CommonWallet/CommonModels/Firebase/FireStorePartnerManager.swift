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
        print(partner)
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

    /**
     FireStorageからパートナー情報を取得
     - Description
     - addSnapshotListenerが3つネストしていて, かなり複雑な処理になっている
     - parameter myUserId: 自身のユーザーID
     - parameter partnerUserId: パートナーのユーザーID
     */
    func realtimeFetchInfo(myUserId: String, completion: @escaping(Partner?, Error?) -> Void) {
        // 自分のFireStoreからpartnerUserIdを取得、なければnilをreturn
        db.collection("Users").document(myUserId)
            .addSnapshotListener { querySnapshot, error in

                if let error = error {
                    print("FireStore PartnerInfo Fetch Error")
                    completion(nil, error)
                }
                guard let data = querySnapshot?.data(),
                      let partnerUserId = data["partnerUserId"] as? String else {
                    completion(nil, nil)
                    return
                }

                // partnerUserIdからpartnerのデータを取得
                self.db.collection("Users").document(partnerUserId)
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

                        // パートナーのIconPathが変更されていた場合、パートナーのIconDataを取得する
                        guard let userDefaultsPartnerIconPath = userDefaultManager.getPartnerIconImagePath(),
                              let partnerIconData = userDefaultManager.getPartnerIconImageData() else {
                            completion(nil, UserDefaultsError.emptyUserIds)
                            return
                        }
                        if partnerIconPath != userDefaultsPartnerIconPath {
                            self.storageManager.download(path: partnerIconPath, completion: { data, error in

                                if let error = error {
                                    completion(nil, error)
                                }

                                guard let data = data else {
                                    completion(nil, NSError())
                                    return
                                }

                                // return処理
                                let partner = Partner(
                                    userId: partnerUserId,
                                    userName: partnerUserName,
                                    shareNumber: partnerShareNumber,
                                    iconPath: partnerIconPath,
                                    iconData: data
                                )
                                completion(partner, nil)
                            })
                        } else {
                            // return処理
                            let partner = Partner(
                                userId: partnerUserId,
                                userName: partnerUserName,
                                shareNumber: partnerShareNumber,
                                iconPath: partnerIconPath,
                                iconData: partnerIconData
                            )
                            completion(partner, nil)
                        }
                    } // ネストのdbここまで
            }// はじめのdbここまで
    }

}
