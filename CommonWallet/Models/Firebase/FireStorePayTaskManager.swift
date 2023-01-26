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

class FireStorePayTaskManager {

    private let db = Firestore.firestore()

    func createPayTask(userUid: String, title: String, memo: String, cost: Int, isMyPayment: Bool) async throws {
        let payment: Dictionary<String, Any> = ["userUid": userUid,
                                             "title": title,
                                             "memo": memo,
                                             "cost": cost,
                                             "isMyPay": isMyPayment,
                                             "createdAt": Timestamp(),
                                             "isFinished": false]
        do {
            try await db.collection("PayTask").document().setData(payment)
        } catch {
            throw error
        }
    }

    func deletePayTask(paymentUid: String) async throws {
        do {
            try await db.collection("PayTask").document(paymentUid).delete()
        } catch {
            throw error
        }
    }

    func fetchPaidPayments(completion: @escaping([PayTask]?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // TODO: パートナーの絞り込みも追加しないといけない
        db.collection("PayTask")
            .whereField("userUid", isEqualTo: uid)
            .whereField("isFinished", isEqualTo: true)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapShots, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                print("FirestoreからPaymentsの取得に成功")
                var payments = [PayTask]()

                snapShots?.documents.forEach({ snapShot in
                    let data = snapShot.data()
                    guard let userUid = data["userUid"] as? String,
                          let title = data["title"] as? String,
                          let cost = data["cost"] as? Int,
                          let isMyPayment = data["isMyPay"] as? Bool,
                          let createdAt = data["createdAt"] as? Timestamp,
                          let isFinished = data["isFinished"] as? Bool else {
                        print("データにnilが発見されてエラー")
                        completion(nil, error)
                        return
                    }

                    let payment = PayTask(
                        userUid: userUid,
                        title: title,
                        cost: cost,
                        isMyPay: isMyPayment,
                        createdAt: createdAt,
                        isFinished: isFinished
                    )

                    payments.append(payment)
                })

                completion(payments, nil)
            }
    }

    func fetchUnpaidPayments(completion: @escaping([PayTask]?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // TODO: パートナーの絞り込みも追加しないといけない
        db.collection("PayTask")
            .whereField("userUid", isEqualTo: uid)
            .whereField("isFinished", isEqualTo: false)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapShots, error in
                if let error = error {
                    print("FirestoreからPaymentsの取得に失敗", error)
                    completion(nil, error)
                    return
                }
                print("FirestoreからPaymentsの取得に成功")
                var payments = [PayTask]()

                snapShots?.documents.forEach({ snapShot in
                    let data = snapShot.data()
                    guard let userUid = data["userUid"] as? String,
                          let title = data["title"] as? String,
                          let cost = data["cost"] as? Int,
                          let isMyPayment = data["isMyPay"] as? Bool,
                          let createdAt = data["createdAt"] as? Timestamp,
                          let isFinished = data["isFinished"] as? Bool else {
                        print("データにnilが発見されてエラー")
                        completion(nil, error)
                        return
                    }

                    let payment = PayTask(
                        userUid: userUid,
                        title: title,
                        cost: cost,
                        isMyPay: isMyPayment,
                        createdAt: createdAt,
                        isFinished: isFinished
                    )

                    payments.append(payment)
                })

                completion(payments, nil)
            }
    }

}
