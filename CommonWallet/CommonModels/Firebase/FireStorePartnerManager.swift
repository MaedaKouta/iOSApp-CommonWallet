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
        guard let partnerUserId = userDefaultManager.getPartnerUid() else {
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

    // 相手が連携削除していたら、自分のUserDefaultから相手を削除する処理。アプリ起動時に毎回行う。
    // addSnapshotListenerにしてfetchPartnerの命名にしよう
    func fetchDeletePartner() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        // 自分のpartnerUidに値がセットされているかチェック
        do {
            let snapShots = try await db.collection("Users")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()

            snapShots.documents.forEach({ snapShot in
                let data = snapShot.data()
                guard let _ = data["partnerUserId"] as? String else {
                    // partnerUidが空だった
                    userDefaultManager.deletePartner()
                    return
                }
            })

        } catch {
            // TODO: 例外処理
            return
        }
    }

}
