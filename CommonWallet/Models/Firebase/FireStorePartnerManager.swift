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

    func connectPartner(partnerShareNumber: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var partnerUid: String = ""

        // パートナーのshareNumberからUidを探る
        do {
            let snapShots = try await db.collection("Users")
                .whereField("myShareNumber", isEqualTo: partnerShareNumber)
                .getDocuments()

            if snapShots.documents.count == 1 {
                let data = snapShots.documents[0].data()
                guard let uid = data["userUid"] as? String else {
                    return
                }
                partnerUid = uid
            } else {
                return
            }

        } catch {
            // 例外処理
        }

        // FireStoreにセットする
        do {
            try await db.collection("Users")
                .document(uid)
                .setData([
                    "partnerUid": partnerUid,
                ], merge: true)
        } catch {
            // 例外処理
        }

        // UserDefaultにセットする
        userDefaultManager.partnerUid = partnerUid

    }
}
