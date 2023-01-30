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

class FireStorePayInfoManager {

    private let db = Firestore.firestore()

    func createPayInfo(userUid: String, title: String, memo: String, cost: Int, isMyPay: Bool) async throws {
        let payInfo: Dictionary<String, Any> = ["userUid": userUid,
                                             "title": title,
                                             "memo": memo,
                                             "cost": cost,
                                             "isMyPay": isMyPay,
                                             "createdAt": Timestamp(),
                                             "isFinished": false]
        do {
            try await db.collection("PayInfo").document().setData(payInfo)
        } catch {
            throw error
        }
    }

    func deletePayInfo(payInfoUid: String) async throws {
        do {
            try await db.collection("PayInfo").document(payInfoUid).delete()
        } catch {
            throw error
        }
    }

    func fetchUnpaidPayInfo(completion: @escaping([PayInfo]?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // TODO: パートナーの絞り込みも追加しないといけない
        // TODO: OrderByをつけるとなぜかうまく通信できない
        db.collection("PayInfo")
            .whereField("userUid", isEqualTo: uid)
            .whereField("isFinished", isEqualTo: false)
            //.order(by: "createdAt", descending: false)
            .addSnapshotListener { snapShots, error in
                if let error = error {
                    print("FirestoreからPaymentsの取得に失敗", error)
                    completion(nil, error)
                    return
                }
                print("FirestoreからPaymentsの取得に成功")
                var payInfos = [PayInfo]()

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

                    let payInfo = PayInfo(
                        userUid: userUid,
                        title: title,
                        cost: cost,
                        isMyPay: isMyPayment,
                        createdAt: createdAt,
                        isFinished: isFinished
                    )

                    payInfos.append(payInfo)
                })

                completion(payInfos, nil)
            }
    }

    func fetchPaidPayInfo(completion: @escaping([PayInfo]?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // TODO: パートナーの絞り込みも追加しないといけない
        db.collection("PayInfo")
            .whereField("userUid", isEqualTo: uid)
            .whereField("isFinished", isEqualTo: true)
            //.order(by: "createdAt", descending: false)
            .addSnapshotListener { snapShots, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                print("FirestoreからPaymentsの取得に成功")
                var payInfos = [PayInfo]()

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

                    let payInfo = PayInfo(
                        userUid: userUid,
                        title: title,
                        cost: cost,
                        isMyPay: isMyPayment,
                        createdAt: createdAt,
                        isFinished: isFinished
                    )

                    payInfos.append(payInfo)
                })

                completion(payInfos, nil)
            }
    }



//    func fetchMyPayments(completion: @escaping([PayTask]?, Error?) -> Void) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        // TODO: パートナーの絞り込みも追加しないといけない
//        db.collection("PayTask")
//            .whereField("userUid", isEqualTo: uid)
//            .whereField("isFinished", isEqualTo: false)
//            .order(by: "createdAt", descending: true)
//            .addSnapshotListener { snapShots, error in
//                if let error = error {
//                    print("FirestoreからPaymentsの取得に失敗", error)
//                    completion(nil, error)
//                    return
//                }
//                print("FirestoreからPaymentsの取得に成功")
//                var payments = [PayTask]()
//
//                snapShots?.documents.forEach({ snapShot in
//                    let data = snapShot.data()
//                    guard let userUid = data["userUid"] as? String,
//                          let title = data["title"] as? String,
//                          let cost = data["cost"] as? Int,
//                          let isMyPayment = data["isMyPay"] as? Bool,
//                          let createdAt = data["createdAt"] as? Timestamp,
//                          let isFinished = data["isFinished"] as? Bool else {
//                        print("データにnilが発見されてエラー")
//                        completion(nil, error)
//                        return
//                    }
//
//                    let payment = PayTask(
//                        userUid: userUid,
//                        title: title,
//                        cost: cost,
//                        isMyPay: isMyPayment,
//                        createdAt: createdAt,
//                        isFinished: isFinished
//                    )
//
//                    payments.append(payment)
//                })
//
//                completion(payments, nil)
//            }
//    }

}
