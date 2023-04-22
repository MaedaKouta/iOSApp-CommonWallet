//
//  TransactionManaging.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/22.
//

import Foundation

protocol FirestoreTransactionManager {
    func fetchResolvedTransactions(userId: String) async throws -> [Transaction]?
    func fetchUnResolvedTransactions(userId: String) async throws -> [Transaction]?
    func addResolvedAt(transactionId: String, resolvedAt: Date) async throws
}
