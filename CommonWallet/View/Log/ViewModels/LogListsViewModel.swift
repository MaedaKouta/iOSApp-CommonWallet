//
//  LogListsViewModel.swift
//  CommonWallet
//

import Foundation
import Parchment

class LogListsViewModel: ObservableObject {

    private var fireStoreTransactionManager: FireStoreTransactionManager

    init(fireStoreTransactionManager: FireStoreTransactionManager) {
        self.fireStoreTransactionManager = fireStoreTransactionManager
    }

    /**
     精算済みのトランザクションを未清算に戻す
     - parameter transactionId: 未清算に戻すトランザクションID
     */
    func updateCancelResolvedAt(transactionId: String) async throws {
        try await fireStoreTransactionManager.updateCancelResolvedAt(transactionId: transactionId)
    }

    /**
     指定したトランザクションを削除する
     - parameter transactionId: 削除するトランザクションID
     */
    func deleteTransaction(transactionId: String) async throws {
        try await fireStoreTransactionManager.deleteTransaction(transactionId: transactionId)
    }

}
