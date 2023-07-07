//
//  CommonWalletViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseFirestore
import SwiftUI

final class CommonWalletViewModel: ObservableObject {

    private var fireStoreTransactionManager: FireStoreTransactionManager
    private var fireStoreUserManager: FireStoreUserManager

    @AppStorage(UserDefaultsKey().userId) private var myUserId = String()
    @AppStorage(UserDefaultsKey().userName) private var myUserName = String()
    @AppStorage(UserDefaultsKey().partnerModifiedName) private var partnerModifiedName = String()

    init(fireStoreTransactionManager: FireStoreTransactionManager, fireStoreUserManager: FireStoreUserManager) {
        self.fireStoreTransactionManager = fireStoreTransactionManager
        self.fireStoreUserManager = fireStoreUserManager
    }

    /**
     指定したトランザクションを削除する
     - parameter transactionId: 削除するトランザクションID
     */
    func deleteTransaction(transactionId: String) async throws {
        try await fireStoreTransactionManager.deleteTransaction(transactionId: transactionId)
    }

    /**
     未精算の複数のトランザクションを精算済みにする
     */
    func updateResolvedTransactions(transactionIds: [String]) async throws {
        try await fireStoreTransactionManager.updateResolvedAt(transactionIds: transactionIds, resolvedAt: Date())
    }

    /**
     未精算の1つののトランザクションを精算済みにする
     - parameter transactionId: 精算済みにするトランザクションID
     */
    func updateResolvedTransaction(transactionId: String) async throws {
        try await fireStoreTransactionManager.updateResolvedAt(transactionId: transactionId, resolvedAt: Date())
    }

}
