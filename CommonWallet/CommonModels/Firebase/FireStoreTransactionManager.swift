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

class FireStoreTransactionManager: FireStoreTransactionManaging {

    private let db = Firestore.firestore()
    private var userDefaultsManager = UserDefaultsManager()

    // MARK: Create
    func createTransaction(transactionId: String, creditorId: String?, debtorId: String?,  title: String, description: String, amount: Int) async throws {

        // Firestoreに書き込むデータの作成
        let transaction: Dictionary<String, Any> = ["id": transactionId,
                                                    "creditorId": creditorId ?? NSNull(),
                                                    "debtorId": debtorId ?? NSNull(),
                                                    "title": title,
                                                    "description": description,
                                                    "amount": amount,
                                                    "createdAt": Timestamp(),
                                                    "resolvedAt": NSNull()]

        // Firestoreへのトランザクション書き込み
        try await db.collection("Transactions").document(transactionId).setData(transaction)
    }

    // TODO: バッチで書き込める上限は500件まで、現状500以上はエラーが起きてしまう
    func pushResolvedAt(transactionIds: [String], resolvedAt: Date) async throws {
        let batch = db.batch()

        for transactionId in transactionIds {
            let documentResolved = db.collection("Transactions").document(transactionId)
            batch.updateData(["resolvedAt": Timestamp(date: resolvedAt)], forDocument: documentResolved)
        }

        try await batch.commit()
    }

    // MARK: UPDATE
    func updateTransaction(transaction: Transaction) async throws {
        let data: Dictionary<String, Any> = ["id": transaction.id,
                                             "creditorId": transaction.creditorId ?? NSNull(),
                                             "debtorId": transaction.debtorId ?? NSNull(),
                                             "title": transaction.title,
                                             "description": transaction.description,
                                             "amount": transaction.amount]

        try await db.collection("Transactions")
            .document(transaction.id)
            .setData(data, merge: true)
    }

    // MARK: Delete
    func deleteTransaction(transactionId: String) async throws {
        try await db.collection("Transactions").document(transactionId).delete()
    }

    // MARK: Fetch
    func fetchUnResolvedTransactions(completion: @escaping([Transaction]?, Error?) -> Void) {

        guard let userId = Auth.auth().currentUser?.uid else { return }
        let partnerId = userDefaultsManager.getPartnerUid() ?? ""

        // Transactionsコレクションから未精算の取引を取得する
        // inを含むwhereFieldとorderByは同時に使えない
        db.collection("Transactions")
            .whereField("creditorId", in: [partnerId, userId])
            .whereField("resolvedAt", isEqualTo: NSNull())
            .addSnapshotListener { snapShots, error in

                if let error = error {
                    print("FireStore UnResolvedTransactions Fetch Error")
                    completion(nil, error)
                }

                // creditorIdもdebtorIdもパートナー連携していない場合のため空でも許される
                var transactions = [Transaction]()
                snapShots?.documents.forEach({ snapShot in
                    let data = snapShot.data()
                    guard let id = data["id"] as? String,
                          let title = data["title"] as? String,
                          let description = data["description"] as? String,
                          let amount = data["amount"] as? Int,
                          let createdAt = data["createdAt"] as? Timestamp  else { return }

                    let debtorId = data["creditorId"] as? String
                    let creditorId = data["creditorId"] as? String

                    let transaction = Transaction(id: id, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount, createdAt: createdAt.dateValue())
                    transactions.append(transaction)
                })
                completion(transactions, nil)
            }
    }

    func fetchResolvedTransactions(completion: @escaping([Transaction]?, Error?) -> Void) {

        guard let userId = Auth.auth().currentUser?.uid else { return }
        let partnerId = userDefaultsManager.getPartnerUid() ?? ""

        // inを含むwhereFieldとorderByは同時に使えない
        db.collection("Transactions")
            .whereField("creditorId", in: [partnerId, userId])
            .whereField("resolvedAt", isNotEqualTo: NSNull())
            .addSnapshotListener { snapShots, error in

                // TODO: 初期で２周している
                if let error = error {
                    print("FireStore ResolvedTransactions Fetch Error")
                    completion(nil, error)
                }

                var transactions = [Transaction]()
                snapShots?.documents.forEach({ snapShot in
                    let data = snapShot.data()
                    guard let id = data["id"] as? String,
                          let title = data["title"] as? String,
                          let description = data["description"] as? String,
                          let amount = data["amount"] as? Int,
                          let createdAt = data["createdAt"] as? Timestamp,
                          let resolvedAt = data["resolvedAt"] as? Timestamp else { return }

                    let creditorId = data["creditorId"] as? String
                    let debtorId = data["debtorId"] as? String

                    let transaction = Transaction(id: id, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount, createdAt: createdAt.dateValue(), resolvedAt: resolvedAt.dateValue())
                    transactions.append(transaction)
                })
                completion(transactions, nil)
            }
    }

    /// 一番古いトランザクションデータを取得する
    func fetchOldestDate(completion: @escaping(Date?, Error?) -> Void) {

        guard let userId = Auth.auth().currentUser?.uid else { return }
        let partnerId = userDefaultsManager.getPartnerUid() ?? ""

        // Transactionsコレクションから未精算の取引を取得する
        db.collection("Transactions")
            .whereField("creditorId", in: [partnerId, userId])
            .whereField("resolvedAt", isNotEqualTo: NSNull())
            .limit(to: 1)
            .getDocuments { snapShots, error in

                if let error = error {
                    print("FireStore OldestDate Fetch Error")
                    completion(nil, error)
                }

                guard let snapshots = snapShots, let doc = snapshots.documents.first else { return }
                let oldestTimestamp = doc.get("createdAt") as? Timestamp

                completion(oldestTimestamp?.dateValue(), nil)
            }
    }

}





