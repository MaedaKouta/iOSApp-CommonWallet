//
//  EditTransactionViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth

class EditTransactionViewModel: ObservableObject {

    private var fireStoreTransactionManager: FireStoreTransactionManager
    private var userDefaultsManager: UserDefaultsManager

    @Published var newTransaction: Transaction
    @Published var beforeTransaction: Transaction
    @Published var selectedIndex: Int

    init(fireStoreTransactionManager: FireStoreTransactionManager,
         userDefaultsManager: UserDefaultsManager,
         transaction: Transaction) {

        self.fireStoreTransactionManager = fireStoreTransactionManager
        self.userDefaultsManager = userDefaultsManager
        self.newTransaction = transaction
        self.beforeTransaction = transaction

        // 立て替えた人 == 自分なら、selectedIndexを0にする
        if transaction.creditorId == self.userDefaultsManager.getUser()?.id {
            self.selectedIndex = 0
        } else {
            self.selectedIndex = 1
        }
    }

    func updateTransaction() async throws -> Result<Void, Error> {
        do {
            try await self.fireStoreTransactionManager.updateTransaction(transaction: newTransaction)
            return .success(())
        } catch {
            return .failure(error)
        }
    }

}
