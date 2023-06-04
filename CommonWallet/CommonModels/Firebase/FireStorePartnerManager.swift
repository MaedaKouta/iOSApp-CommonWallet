//
//  FireStoreConnectPatnerManager.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

class FireStorePartnerManager: FireStorePartnerManaging {

    private let db = Firestore.firestore()
    private var userDefaultManager = UserDefaultsManager()
    private var storageManager = StorageManager()

    /*
     パートナーと接続し、接続した情報を自分のUserdefaultsに格納する
     */
    func connectPartner(partnerShareNumber: String) async -> Result<Bool, Error> {
        guard let myUserId = Auth.auth().currentUser?.uid else {
            return .failure(AuthError.emptyUserId)
        }

        do {
            // パートナーのshareNumberからpartnerUserIdを探る
            let snapShots = try await db.collection("Users")
                .whereField("shareNumber", isEqualTo: partnerShareNumber)
                .getDocuments()

            guard let data = snapShots.documents.first?.data(),
                  let partnerUserId = data["id"] as? String,
                  let partnerIconPath = data["iconPath"] as? String,
                  let partnerName = data["name"] as? String else {
                return .failure(InvalidValueError.unexpectedNullValue)
            }

            // 自分のPartnerIdに相手のIdを入れる
            try await db.collection("Users")
                .document(myUserId)
                .setData([
                    "partnerUserId": partnerUserId,
                ], merge: true)

            // 相手のPartnerIdに自分のIdを入れる
            try await db.collection("Users")
                .document(partnerUserId)
                .setData([
                    "partnerUserId": myUserId,
                ], merge: true)

            // UserDefaultにセットする
            storageManager.download(path: partnerIconPath, completion: { [weak self] data, error in
                if error != nil {
                    print("FireStorePartnerManager: storageManager.downloadエラー")
                    self?.userDefaultManager.setPartnerUserId(userId: partnerUserId)
                    self?.userDefaultManager.setPartnerName(name: partnerName)
                    self?.userDefaultManager.setPartnerShareNumber(shareNumber: partnerShareNumber)
                } else {
                    self?.userDefaultManager.setPartner(userId: partnerUserId, name: partnerName, iconPath:partnerIconPath, iconData: data! ,shareNumber: partnerShareNumber)
                }
            })

            return .success(true)

        } catch {
            return .failure(error)
        }

    }

    func deletePartner() async -> Result<Bool, Error> {
        guard let myUserId = Auth.auth().currentUser?.uid else {
            return .failure(AuthError.emptyUserId)
        }
        guard let partnerUserId = userDefaultManager.getPartnerUserId() else {
            return .failure(UserDefaultsError.emptyPartnerUserId)
        }

        // お互いにFireStoreから削除する
        do {
            try await db.collection("Users")
                .document(myUserId)
                .setData([
                    "partnerUserId": FieldValue.delete(),
                ], merge: true)

            try await db.collection("Users")
                .document(partnerUserId)
                .setData([
                    "partnerUserId": FieldValue.delete(),
                ], merge: true)

            // UserDefaultにセットする
            userDefaultManager.deletePartner()
            return .success(true)

        } catch {
            return .failure(error)
        }

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
