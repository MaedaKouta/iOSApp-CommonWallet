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

// TODO: パートナーの改名もUserDefaultsだけじゃなくFireStoreに保存する処理追加する
class FireStorePartnerManager: FireStorePartnerManaging {

    private let db = Firestore.firestore()
    private var userDefaultManager = UserDefaultsManager()

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
            userDefaultManager.setPartner(userId: partnerUserId, name: partnerName, shareNumber: partnerShareNumber)
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

    // パートナーとの紐付け
    // パートナー
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
                              let partnerShareNumber = data["shareNumber"] as? String else {
                            completion(nil, InvalidValueError.unexpectedNullValue)
                            return
                        }

                        let user = User(name: myUserInfo.name, email: myUserInfo.email, shareNumber: myUserInfo.shareNumber, createdAt: myUserInfo.createdAt, partnerUserId: partnerUserId, partnerName: partnerName, partnerShareNumber: partnerShareNumber)

                        completion(user, nil)
                    } // ネストのdbここまで
            }// はじめのdbここまで
    }

}
