//
//  TransactionManaging.swift
//  CommonWallet
//

import Foundation

protocol FireStoreTransactionManaging {

    // POST
    func createTransaction(transactionId: String, creditorId: String?, debtorId: String?,  title: String, description: String, amount: Int) async throws

    // PUT
    func updateResolvedAt(transactionIds: [String], resolvedAt: Date) async throws
    func updateResolvedAt(transactionId: String, resolvedAt: Date) async throws
    func updateTransaction(transaction: Transaction) async throws

    // DELETE
    func deleteTransaction(transactionId: String) async throws

    // GET
    func fetchUnResolvedTransactions(myUserId: String, partnerUserId: String, completion: @escaping([Transaction]?, Error?) -> Void)
    func fetchResolvedTransactions(myUserId: String, partnerUserId: String, completion: @escaping([Transaction]?, Error?) -> Void)
    func fetchOldestDate(myUserId: String, partnerUserId: String) async throws -> Date?

}
