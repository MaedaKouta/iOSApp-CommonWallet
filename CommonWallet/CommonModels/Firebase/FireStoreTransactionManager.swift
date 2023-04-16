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
    // transactionの生成
    func createTransaction(transactionId: String, creditorId: String, debtorId: String,  title: String, description: String, amount: Int) async throws {

        // Firestoreに書き込むデータの作成
        let transaction: Dictionary<String, Any> = ["id": transactionId,
                                                    "creditorId": creditorId,
                                                    "debtorId": debtorId,
                                                    "title": title,
                                                    "description": description,
                                                    "amount": amount,
                                                    "createdAt": Timestamp()]

        // Firestoreへのトランザクション書き込み
        try await db.collection("Transactions").document(transactionId).setData(transaction)

        // クレジット側のユーザーデータの更新
        try await db.collection("Users").document(creditorId)
            .updateData([
                "transactionIds": FieldValue.arrayUnion([transactionId])
            ])

        // デビット側のユーザーデータの更新
        try await db.collection("Users").document(debtorId)
            .updateData([
                "transactionIds": FieldValue.arrayUnion([transactionId])
            ])
    }

    // transactionに精算完了時間の追加
    func addResolvedAt(transactionId: String, resolvedAt: Date) async throws {
        try await db.collection("Transactions").document(transactionId)
            .updateData([
                "resolvedAt": resolvedAt
            ])
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
    private func fetchTransactionIds(userId: String) async throws -> [String] {
        let document = try await db.collection("Users").document(userId).getDocument()
        guard let data = document.data(),
              let transactionIds = data["transactionIds"] as? [String] else {
            throw FetchTransactionsError.emptyTransactionIds
        }
        return transactionIds
    }

    private func fetchTransactionData(transactionId: String) async throws -> [String: Any] {
        let document = try await db.collection("Transactions").document(transactionId).getDocument()
        guard let data = document.data() else {
            throw FetchTransactionsError.emptyTransactionData
        }
        return data
    }

    func fetchResolvedTransactions(userId: String) async throws -> [Transaction]? {
        var transactions: [Transaction] = []
        let transactionIds = try await fetchTransactionIds(userId: userId)

        for transactionId in transactionIds {
            let transactionData = try await fetchTransactionData(transactionId: transactionId)
            guard let id = transactionData["id"] as? String,
               let creditorId = transactionData["creditorId"] as? String,
               let debtorId = transactionData["debtorId"] as? String,
               let title = transactionData["title"] as? String,
               let description = transactionData["description"] as? String,
               let amount = transactionData["amount"] as? Int,
               let createdAt = transactionData["createdAt"] as? Timestamp else {
                throw FetchTransactionsError.emptyTransactionData
            }

            // resolvedが存在すれば精算済みと認定
            let resolvedAt = transactionData["resolvedAt"] as? Timestamp
            if let resolvedAt = resolvedAt {
                let transaction = Transaction(id: id, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount, createdAt: createdAt.dateValue(), resolvedAt: resolvedAt.dateValue())
                transactions.append(transaction)
            }
        }

        return transactions
    }

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

    func fetchUnResolvedTransactions(userId: String) async throws -> [Transaction]? {
        var transactions: [Transaction] = []
        let transactionIds = try await fetchTransactionIds(userId: userId)

        for transactionId in transactionIds {
            let transactionData = try await fetchTransactionData(transactionId: transactionId)
            guard let id = transactionData["id"] as? String,
               let creditorId = transactionData["creditorId"] as? String,
               let debtorId = transactionData["debtorId"] as? String,
               let title = transactionData["title"] as? String,
               let description = transactionData["description"] as? String,
               let amount = transactionData["amount"] as? Int,
               let createdAt = transactionData["createdAt"] as? Timestamp else {
                throw FetchTransactionsError.emptyTransactionData
            }

            // resolvedが存在すれば精算済みと認定
            let resolvedAt = transactionData["resolvedAt"] as? Timestamp
            if resolvedAt == nil {
                let transaction = Transaction(id: id, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount, createdAt: createdAt.dateValue(), resolvedAt: nil)
                transactions.append(transaction)
            }
        }

        return transactions
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
