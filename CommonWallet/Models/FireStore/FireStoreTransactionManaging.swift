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
    func updateTransactions(transactions: [Transaction]) async throws
    func updateCancelResolvedAt(transactionId: String) async throws
    func updateCreditorNullOnTransactionIds(transactionIds: [String]) async throws
    func updateDebtorNullOnTransactionIds(transactionIds: [String]) async throws

    // DELETE
    func deleteTransaction(transactionId: String) async throws
    func deleteTransactions(transactionIds: [String]) async throws

    // GET
    func fetchTransactions(myUserId: String, partnerUserId: String?, completion: @escaping([Transaction]?, Error?) -> Void)

}
