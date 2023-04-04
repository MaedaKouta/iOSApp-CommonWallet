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

class FireStoreTransactionManager {

    private let db = Firestore.firestore()

    // MARK: Create
    func createTransaction(transactionId: String, creditorId: String, debtorId: String,  title: String, description: String, amount: Int) async throws {
        let transaction: Dictionary<String, Any> = ["id": transactionId,
                                                    "creditorId": creditorId,
                                                    "debtorId": debtorId,
                                                    "title": title,
                                                    "description": description,
                                                    "amount": amount,
                                                    "createdAt": Timestamp()]
        do {
            try await db.collection("Transactions").document(transactionId).setData(transaction)

            try await db.collection("Users").document(creditorId)
                .updateData([
                    "transactionIds": FieldValue.arrayUnion([transactionId])
                ])

            try await db.collection("Users").document(debtorId)
                .updateData([
                    "transactionIds": FieldValue.arrayUnion([transactionId])
                ])

        } catch {
            throw error
        }

    }

    // MARK: Delete
    func deleteTransaction(transactionId: String) async throws {
        do {
            try await db.collection("Transacations").document(transactionId).delete()
        } catch {
            throw error
        }
    }

    // MARK: Fetch
    func fetchResolvedTransactions(completion: @escaping([Transaction]?, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        var transactionIds = [String]()
        var transactions = [Transaction]()

        // 自分のUserCollectionからtransactionIds（[String]）を取得
        db.collection("Users").document(userId).getDocument { snapShot, error in
            if let error = error {
                print("Firestoreからユーザ情報の取得に失敗しました")
                completion(nil, error)
            }
            guard let data = snapShot?.data(),
                  let transactionIdsFromData = data["transactionIds"] as? [String] else {
                print("FireStoreのUserCollectionでtransactionIdsが空です")
                return completion(nil, error)
            }
            transactionIds = transactionIdsFromData

            // transactionIds（[String]）をtransactions([transaction])に置き換え
            // TODO: 非同期処理の関係？で値が空で、下のfor文回ってない
            transactionIds.forEach { transactionId in

                self.db.collection("Transactions").document(transactionId).getDocument { snapShot, error in
                    if let error = error {
                        print("FirestoreからTransactionsの取得に失敗しました")
                        completion(nil, error)
                    }
                    guard let data = snapShot?.data(),
                          let id = data["id"] as? String,
                          let creditorId = data["creditorId"] as? String,
                          let debtorId = data["debtorId"] as? String,
                          let title = data["title"] as? String,
                          let description = data["description"] as? String,
                          let amount = data["amount"] as? Int,
                          let createdAt = data["createdAt"] as? Timestamp  else {
                        return }

                    // "精算済み" を調べる
                    let resolvedAt = data["resolvedAt"] as? Timestamp
                    if resolvedAt != nil {
                        let transaction = Transaction(id: id, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount, createdAt: createdAt.dateValue(), resolvedAt: resolvedAt?.dateValue())
                        transactions.append(transaction)
                    }
                    // ここにcompletionを書かないと、非同期？の関係でnilを返してしまう
                    completion(transactions, nil)
                }
            }
        }

    }

    func fetchUnResolvedTransactions(completion: @escaping([Transaction]?, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        var transactionIds = [String]()
        var transactions = [Transaction]()

        // 自分のUserCollectionからtransactionIds（[String]）を取得
        db.collection("Users").document(userId).getDocument { snapShot, error in
            if let error = error {
                print("Firestoreからユーザ情報の取得に失敗しました")
                completion(nil, error)
            }
            guard let data = snapShot?.data(),
                  let transactionIdsFromData = data["transactionIds"] as? [String] else {
                print("FireStoreのUserCollectionでtransactionIdsが空です")
                return completion(nil, error)
            }
            transactionIds = transactionIdsFromData

            // transactionIds（[String]）をtransactions([transaction])に置き換え
            // TODO: 非同期処理の関係？で値が空で、下のfor文回ってない
            transactionIds.forEach { transactionId in

                self.db.collection("Transactions").document(transactionId).getDocument { snapShot, error in
                    if let error = error {
                        print("FirestoreからTransactionsの取得に失敗しました")
                        completion(nil, error)
                    }
                    guard let data = snapShot?.data(),
                          let id = data["id"] as? String,
                          let creditorId = data["creditorId"] as? String,
                          let debtorId = data["debtorId"] as? String,
                          let title = data["title"] as? String,
                          let description = data["description"] as? String,
                          let amount = data["amount"] as? Int,
                          let createdAt = data["createdAt"] as? Timestamp  else {
                        return }

                    // "精算済み" を調べる
                    let resolvedAt = data["resolvedAt"] as? Timestamp
                    if resolvedAt == nil {
                        let transaction = Transaction(id: id, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount, createdAt: createdAt.dateValue(), resolvedAt: resolvedAt?.dateValue())
                        transactions.append(transaction)
                    }
                    // ここにcompletionを書かないと、非同期？の関係でnilを返してしまう
                    completion(transactions, nil)
                }
            }
        }

    }

}
