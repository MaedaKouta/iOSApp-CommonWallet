//
//  FireStoreConnectPatnerManager.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import Foundation
import FirebaseAuth
import Firebase

class FireStorePartnerManager {

    private let db = Firestore.firestore()
    private var userDefaultManager = UserDefaultsManager()

    func connectPartner(partnerShareNumber: String) async -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        var partnerUid: String = ""

        // パートナーのshareNumberからUidを探る
        do {
            let snapShots = try await db.collection("Users")
                .whereField("shareNumber", isEqualTo: partnerShareNumber)
                .getDocuments()

            if snapShots.documents.count == 1 {
                let data = snapShots.documents[0].data()
                guard let uid = data["uid"] as? String else {
                    return false
                }
                partnerUid = uid
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
            print("4")
            return false
        }

        // UserDefaultにセットする
        userDefaultManager.partnerUid = partnerUid

        return true

    }
}
