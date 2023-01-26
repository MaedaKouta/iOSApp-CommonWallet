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

    func deletePayment(paymentUid: String) async throws {
        do {
            try await db.collection("Payments").document(paymentUid).delete()
        } catch {
            throw error
        }
    }

    func fetchPaidPayments() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // TODO: パートナーの絞り込みも追加しないといけない
        db.collection("Payments")
            .whereField("userUID", isEqualTo: uid)
            .whereField("isFinished", isEqualTo: true)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapShots, error in
                if let error = error {
                    print("FirestoreからPaymentsの取得に失敗", error)
                    return
                }
                print("FirestoreからPaymentsの取得に成功")
                var payments = [Payment]()

                snapShots?.documents.forEach({ snapShot in
                    let data = snapShot.data()
                    guard let userUid: String = data["userUid"],
                          let title: String = data["title"],
                          let cost: Int = data["cost"],
                          let isMyPayment: Bool = data["isMyPayment"],
                          let createdAt = data["createdAt"],
                          let isFinished: Bool = data["isFinished"] else {
                        print("データにnilが発見されてエラー")
                        return
                    }

                    let payment = Payment(
                        userUid: userUid,
                        title: title,
                        cost: cost,
                        isMyPayment: isMyPayment,
                        createdAt: createdAt,
                        isFinished: isFinished
                    )

                    payments.append(payment)
                })

                completion(payments, nil)
            }
    }

    func fetchNotPaidPayments() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // TODO: パートナーの絞り込みも追加しないといけない
        db.collection("Payments")
            .whereField("userUID", isEqualTo: uid)
            .whereField("isFinished", isEqualTo: false)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapShots, error in
                if let error = error {
                    print("FirestoreからPaymentsの取得に失敗", error)
                    return
                }
                print("FirestoreからPaymentsの取得に成功")
                var payments = [Payment]()

                snapShots?.documents.forEach({ snapShot in
                    let data = snapShot.data()
                    guard let userUid: String = data["userUid"],
                          let title: String = data["title"],
                          let cost: Int = data["cost"],
                          let isMyPayment: Bool = data["isMyPayment"],
                          let createdAt = data["createdAt"],
                          let isFinished: Bool = data["isFinished"] else {
                        print("データにnilが発見されてエラー")
                        return
                    }

                    let payment = Payment(
                        userUid: userUid,
                        title: title,
                        cost: cost,
                        isMyPayment: isMyPayment,
                        createdAt: createdAt,
                        isFinished: isFinished
                    )

                    payments.append(payment)
                })

                completion(payments, nil)
            }
    }

}
