//
//  FireStorePaymentManager.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

struct FireStoreTransactionManager: FireStoreTransactionManaging {

    private let db = Firestore.firestore()

    // MARK: - POST
    /**
     FireStorageにトランザクションを追加
     - parameter transactionId: transactionId, 生成したものをここに入れる
     - parameter creditorId: 支払い者のUserId（パートナー未登録の場合のためオプショナル）
     - parameter debtorId: 未支払い者のUserId（パートナー未登録の場合のためオプショナル）
     - parameter title: タイトル（空文字不可, 入力前にチェックしておく）
     - parameter description: 詳細
     - parameter amount: 金額
     */
    func createTransaction(transactionId: String, creditorId: String?, debtorId: String?,  title: String, description: String, amount: Int) async throws {

        // Firestoreに書き込むデータの作成
        let transaction: Dictionary<String, Any> = ["id": transactionId,
                                                    "creditorId": creditorId ?? "",
                                                    "debtorId": debtorId ?? "",
                                                    "title": title,
                                                    "description": description,
                                                    "amount": amount,
                                                    "createdAt": Timestamp(),
                                                    "resolvedAt": NSNull()]
        try await db.collection("Transactions").document(transactionId).setData(transaction)
    }


    // MARK: - PUT
    /**
     FireStorageで複数の未精算トランザクションを精算する
     - Description
     - 内部でバッチでまとめて書き込む処理をしている
     - バッチで書き込める上限は500件まで
     - 上限の制約を満たすために300件ごとに分割して、分割したものを繰り返しバッチで書き込む
     - parameter transactionIds: 生産完了にしたいtransactionIdの配列
     - parameter resolvedAt: 精算日時
     */
    func updateResolvedAt(transactionIds: [String], resolvedAt: Date) async throws {
        let splitTransactionIds = transactionIds.splitIntoChunks(ofSize: 300)
        for transactionIds in splitTransactionIds {
            let batch = db.batch()
            for transactionId in transactionIds {
                let documentResolved = db.collection("Transactions").document(transactionId)
                batch.updateData(["resolvedAt": Timestamp(date: resolvedAt)], forDocument: documentResolved)
            }
            try await batch.commit()
        }
    }

    /**
     FireStorageで1つの未精算トランザクションを精算する
     - parameter transactionIds: 精算完了にしたいtransactionIdの配列
     - parameter resolvedAt: 精算日時
     */
    func updateResolvedAt(transactionId: String, resolvedAt: Date) async throws {
        let transaction: Dictionary<String, Any> = ["resolvedAt": Timestamp(date: resolvedAt)]
        try await db.collection("Transactions").document(transactionId).setData(transaction, merge: true)
    }

    /**
     精算済みのトランザクションを未清算に戻す
     - parameter transactionIds: 精算を未清算に戻したいtransactionIdの配列
     */
    func updateCancelResolvedAt(transactionId: String) async throws {
        let transaction: Dictionary<String, Any> = ["resolvedAt": NSNull()]
        try await db.collection("Transactions").document(transactionId).setData(transaction, merge: true)
    }


    /**
     FireStorageのトランザクションを上書きする
     - parameter transaction: 上書きするtransactionデータ
     */
    func updateTransaction(transaction: Transaction) async throws {
        let data: Dictionary<String, Any> = ["id": transaction.id,
                                             "creditorId": transaction.creditorId ?? "",
                                             "debtorId": transaction.debtorId ?? "",
                                             "title": transaction.title,
                                             "description": transaction.description,
                                             "amount": transaction.amount,
                                             "createdAt": transaction.createdAt,
                                             "resolvedAt": transaction.resolvedAt ?? NSNull()]

        try await db.collection("Transactions")
            .document(transaction.id)
            .setData(data, merge: true)
    }

    /**
     複数のFireStorageのトランザクションを上書きする
     - parameter transaction: 上書きするtransactionデータの配列
     */
    func updateTransactions(transactions: [Transaction]) async throws {
        let splitTransactions = transactions.splitIntoChunks(ofSize: 300)

        for transactions in splitTransactions {
            let batch = db.batch()
            for transaction in transactions {
                let document = db.collection("Transactions").document(transaction.id)
                let data: Dictionary<String, Any> = ["id": transaction.id,
                                                     "creditorId": transaction.creditorId ?? "",
                                                     "debtorId": transaction.debtorId ?? "",
                                                     "title": transaction.title,
                                                     "description": transaction.description,
                                                     "amount": transaction.amount,
                                                     "createdAt": transaction.createdAt,
                                                     "resolvedAt": transaction.resolvedAt ?? NSNull()]
                batch.updateData(data, forDocument: document)
            }
            try await batch.commit()
        }
    }

    /**
     FireStorageトランザクションのCreditorをNullにする
     - parameter transaction: Nullにするtransactionデータの配列
     */
    func updateCreditorNullOnTransactionIds(transactionIds: [String]) async throws {
        let creditorNullOnTransaction: Dictionary<String, Any> = ["creditorId": ""]
        let splitTransactionIds = transactionIds.splitIntoChunks(ofSize: 300)

        for transactionIds in splitTransactionIds {
            let batch = db.batch()
            for transactionId in transactionIds {
                let document = db.collection("Transactions").document(transactionId)
                batch.updateData(creditorNullOnTransaction, forDocument: document)
            }
            try await batch.commit()
        }
    }

    /**
     FireStorageトランザクションのdebtorをNullにする
     - parameter transaction: Nullにするtransactionデータの配列
     */
    func updateDebtorNullOnTransactionIds(transactionIds: [String]) async throws {
        let creditorNullOnTransaction: Dictionary<String, Any> = ["debtorId": ""]
        let splitTransactionIds = transactionIds.splitIntoChunks(ofSize: 300)

        for transactionIds in splitTransactionIds {
            let batch = db.batch()
            for transactionId in transactionIds {
                let document = db.collection("Transactions").document(transactionId)
                batch.updateData(creditorNullOnTransaction, forDocument: document)
            }
            try await batch.commit()
        }
    }


    // MARK: - Delete
    /**
     単一のFireStorageのトランザクションを削除する
     - parameter transactionId: 削除するtransactionId
     */
    func deleteTransaction(transactionId: String) async throws {
        try await db.collection("Transactions").document(transactionId).delete()
    }

    /**
     複数のFireStorageのトランザクションを削除する
     - Description
     - アカウント削除する際に利用
     - parameter transactionIds: 削除するtransactionIdの配列
     */
    func deleteTransactions(transactionIds: [String]) async throws {
        let splitTransactionIds = transactionIds.splitIntoChunks(ofSize: 300)
        for transactionIds in splitTransactionIds {
            let batch = db.batch()
            for transactionId in transactionIds {
                let document = db.collection("Transactions").document(transactionId)
                batch.deleteDocument(document)
            }
            try await batch.commit()
        }
    }


    // MARK: - GET
    /**
     未精算のトランザクションを取得する
     - parameter myUserId: 自分のUserId
     - parameter partnerUserId: パートナーのUserId
     */
    /**
     精算済のトランザクションを取得する
     - parameter myUserId: 自分のUserId
     - parameter partnerUserId: パートナーのUserId
     */
    func fetchTransactions(myUserId: String, partnerUserId: String?, completion: @escaping([Transaction]?, Error?) -> Void) {

        // パートナーが""で渡ってくるので、ほぼ全検索みたいな状態になってしまう。
        // 空文字列で来た際は、"xxx"をFireStoreで調べるようにして、全検索にならないようにする
        var searchPartnerUserId = partnerUserId
        if let partnerUserId = partnerUserId {
            if partnerUserId.isEmpty {
                searchPartnerUserId = "xxx"
            }
        }

        // inを含むwhereFieldとorderByは同時に使えない
        db.collection("Transactions")
            .whereField("creditorId", in: [searchPartnerUserId, myUserId])
            .addSnapshotListener { snapShots, error in

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
                          let createdAt = data["createdAt"] as? Timestamp else { return }

                    // creditorIdもdebtorIdもパートナー連携していない場合のため空でも許される
                    let creditorId = data["creditorId"] as? String
                    let debtorId = data["debtorId"] as? String
                    let resolvedAt = data["resolvedAt"] as? Timestamp

                    let transaction = Transaction(id: id, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount, createdAt: createdAt.dateValue(), resolvedAt: resolvedAt?.dateValue())
                    transactions.append(transaction)
                })
                completion(transactions, nil)
            }
    }

}





