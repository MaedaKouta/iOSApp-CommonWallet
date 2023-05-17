//
//  TransactionManaging.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/22.
//

import Foundation

protocol FireStoreTransactionManaging {

    // create
    func createTransaction(transactionId: String, creditorId: String?, debtorId: String?,  title: String, description: String, amount: Int) async throws

    // push
    func pushResolvedAt(transactionIds: [String], resolvedAt: Date) async throws

    // delete
    func deleteTransaction(transactionId: String) async throws

    // fetch
    func fetchUnResolvedTransactions(completion: @escaping([Transaction]?, Error?) -> Void)
    func fetchResolvedTransactions(completion: @escaping([Transaction]?, Error?) -> Void)

}
