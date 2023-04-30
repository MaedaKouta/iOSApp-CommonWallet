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
    /// transactionの生成
    func createTransaction(transactionId: String, creditorId: String, debtorId: String,  title: String, description: String, amount: Int) async throws {

        // Firestoreに書き込むデータの作成
        let transaction: Dictionary<String, Any> = ["id": transactionId,
                                                    "creditorId": creditorId,
                                                    "debtorId": debtorId,
                                                    "title": title,
                                                    "description": description,
                                                    "amount": amount,
                                                    "createdAt": Timestamp(),
                                                    "resolvedAt": NSNull()]

        // Firestoreへのトランザクション書き込み
        try await db.collection("Transactions").document(transactionId).setData(transaction)
    }

    // transactionに精算完了時間の追加
    func pushResolvedAt(transactionId: String, resolvedAt: Date) async throws {
        // Firestoreへのトランザクション上書き
        try await db.collection("Transactions")
            .document(transactionId)
            .updateData([
                "resolvedAt": resolvedAt
            ])
    }

    // TODO: バッチで書き込める上限は500件まで、現状500以上はエラーが起きてしまう
    func pushResolvedAt(transactionIds: [String], resolvedAt: Date) async throws {
        let batch = db.batch()

        for transactionId in transactionIds {
            let documentResolved = db.collection("Transactions").document(transactionId)
            batch.updateData(["resolvedAt": resolvedAt], forDocument: documentResolved)
        }

        do {
            try await batch.commit()
            print("Batch write succeeded.")
        } catch {
            print("Error writing batch \(error)")
        }

    }

    // MARK: Delete
    /// transactionの削除
    func deleteTransaction(transactionId: String) async throws {
        // Firestoreへのトランザクション削除
        try await db.collection("Transacations").document(transactionId).delete()
    }

    // MARK: Fetch
    /// 未精算のトランザクションを取得する
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
                    print("FirestoreからTransactionsの取得に失敗しました")
                    completion(nil, error)
                }

                var transactions = [Transaction]()
                snapShots?.documents.forEach({ snapShot in
                    let data = snapShot.data()
                    guard let id = data["id"] as? String,
                          let creditorId = data["creditorId"] as? String,
                          let debtorId = data["debtorId"] as? String,
                          let title = data["title"] as? String,
                          let description = data["description"] as? String,
                          let amount = data["amount"] as? Int,
                          let createdAt = data["createdAt"] as? Timestamp  else { return }

                    let transaction = Transaction(id: id, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount, createdAt: createdAt.dateValue())
                    print(transaction)
                    transactions.append(transaction)
                })
                completion(transactions, error)
            }
    }

    /// 精算済みのトランザクションを取得する
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
                    print("FirestoreからTransactionsの取得に失敗しました")
                    completion(nil, error)
                }

                var transactions = [Transaction]()
                snapShots?.documents.forEach({ snapShot in
                    let data = snapShot.data()
                    guard let id = data["id"] as? String,
                          let creditorId = data["creditorId"] as? String,
                          let debtorId = data["debtorId"] as? String,
                          let title = data["title"] as? String,
                          let description = data["description"] as? String,
                          let amount = data["amount"] as? Int,
                          let createdAt = data["createdAt"] as? Timestamp,
                          let resolvedAt = data["resolvedAt"] as? Timestamp else { return }

                    let transaction = Transaction(id: id, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount, createdAt: createdAt.dateValue(), resolvedAt: resolvedAt.dateValue())
                    transactions.append(transaction)
                })
                completion(transactions, error)
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
                    print("FirestoreからTransactionsの取得に失敗しました")
                    completion(nil, error)
                }

                guard let snapshots = snapShots, let doc = snapshots.documents.first else { return }
                let oldestTimestamp = doc.get("createdAt") as? Timestamp

                completion(oldestTimestamp?.dateValue(), error)
            }
    }

}





