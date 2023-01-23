//
//  FireStorePaymentManager.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

class FireStorePaymentManager {

    private let db = Firestore.firestore()

    func createPayment(userUid: String, title: String, memo: String, cost: Int, isMyPayment: Bool) async throws {
        let payment: Dictionary<String, Any> = ["userUid": userUid,
                                             "title": title,
                                             "memo": memo,
                                             "cost": cost,
                                             "isMyPayment": isMyPayment,
                                             "createdAt": Timestamp(),
                                             "isFinished": false]
        do {
            try await db.collection("Payments").document().setData(payment)
        } catch {
            throw error
        }
    }

    func deletePayment(uid: String) async throws {
        do {
            try await db.collection("Payments").document(uid).delete()
        } catch {
            throw error
        }
    }

}
