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
class FireStorePartnerManager {

    private let db = Firestore.firestore()
    private var userDefaultManager = UserDefaultsManager()

    func connectPartner(partnerShareNumber: String) async -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        var partnerUid: String = ""
        var partnerName: String = ""

        // パートナーのshareNumberからUidを探る
        do {
            let snapShots = try await db.collection("Users")
                .whereField("shareNumber", isEqualTo: partnerShareNumber)
                .getDocuments()

            if snapShots.documents.count == 1 {
                let data = snapShots.documents[0].data()
                guard let uid = data["uid"] as? String,
                let userName = data["userName"] as? String else {
                    return false
                }
                partnerUid = uid
                partnerName = userName
            } else {
                return false
            }

        } catch {
            // TODO: 例外処理
            return false
        }

        // お互いにFireStoreにセットする
        // TODO: 強引にお互いにセットしてるの修正する。相手の承認が必要な感じに
        do {
            try await db.collection("Users")
                .document(uid)
                .setData([
                    "partnerUid": partnerUid,
                ], merge: true)

            try await db.collection("Users")
                .document(partnerUid)
                .setData([
                    "partnerUid": uid,
                ], merge: true)
        } catch {
            // TODO: 例外処理
            return false
        }

        // UserDefaultにセットする
        userDefaultManager.setPartner(uid: partnerUid, name: partnerName, shareNumber: partnerShareNumber)

        return true

    }

    func deletePartner() async -> Bool {
        guard let myUid = Auth.auth().currentUser?.uid else {
            return false
        }
        guard let partnerUid = userDefaultManager.getPartnerUid() else {
            return false
        }

        // お互いにFireStoreから削除する
        // TODO: 強引にお互いにセットしてるの修正する。相手の承認が必要な感じに
        do {
            try await db.collection("Users")
                .document(myUid)
                .setData([
                    "partnerUid": FieldValue.delete(),
                ], merge: true)

            try await db.collection("Users")
                .document(partnerUid)
                .setData([
                    "partnerUid": FieldValue.delete(),
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
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        // 自分のpartnerUidに値がセットされているかチェック
        do {
            let snapShots = try await db.collection("Users")
                .whereField("uid", isEqualTo: uid)
                .getDocuments()

            snapShots.documents.forEach({ snapShot in
                let data = snapShot.data()
                guard let _ = data["partnerUid"] as? String else {
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
