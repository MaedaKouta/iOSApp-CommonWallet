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

    // TODO: 中に入れるエラー変えよう
    func connectPartner(partnerShareNumber: String) async -> Result<Bool, Error> {
        guard let userId = Auth.auth().currentUser?.uid else {
            return .failure(UserDefaultsError.emptyUserIds)
        }
        var partnerUserId: String = ""
        var partnerName: String = ""

        // パートナーのshareNumberからUidを探る
        do {
            let snapShots = try await db.collection("Users")
                .whereField("shareNumber", isEqualTo: partnerShareNumber)
                .getDocuments()

            if snapShots.documents.count == 1 {
                let data = snapShots.documents[0].data()
                guard let userId = data["id"] as? String,
                      let userName = data["name"] as? String else {
                    return .failure(UserDefaultsError.emptyUserIds)
                }
                partnerUserId = userId
                partnerName = userName
            } else {
                return .failure(UserDefaultsError.emptyUserIds)
            }

        } catch {
            // TODO: 例外処理
            return .failure(UserDefaultsError.emptyUserIds)
        }

        // お互いにFireStoreにセットする
        // TODO: 強引にお互いにセットしてるの修正する。相手の承認が必要な感じに
        do {
            try await db.collection("Users")
                .document(userId)
                .setData([
                    "partnerUserId": partnerUserId,
                ], merge: true)

            try await db.collection("Users")
                .document(partnerUserId)
                .setData([
                    "partnerUserId": userId,
                ], merge: true)

        } catch {
            // TODO: 例外処理
            return .failure(UserDefaultsError.emptyUserIds)
        }

        // UserDefaultにセットする
        userDefaultManager.setPartner(userId: partnerUserId, name: partnerName, shareNumber: partnerShareNumber)

        return .success(true)

    }

    func deletePartner() async -> Bool {
        guard let myUserId = Auth.auth().currentUser?.uid else {
            return false
        }
        guard let partnerUserId = userDefaultManager.getPartnerUid() else {
            return false
        }

        // お互いにFireStoreから削除する
        // TODO: 強引にお互いにセットしてるの修正する。相手の承認が必要な感じに
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

        } catch {
            // TODO: 例外処理
            return false
        }

        // UserDefaultにセットする
        // TODO: 自分の方はUserDefault削除できるけど、相手方は削除できていない、改善する。
        userDefaultManager.deletePartner()
        return true

    }

    // 相手が連携削除していたら、自分のUserDefaultから相手を削除する処理。アプリ起動時に毎回行う。
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
