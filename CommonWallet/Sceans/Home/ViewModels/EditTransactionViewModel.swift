//
//  EditTransactionViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/05/06.
//

import Foundation
import FirebaseAuth

class EditTransactionViewModel: ObservableObject {

    private var fireStoreTransactionManager: FireStoreTransactionManager
    private var userDefaultsManager: UserDefaultsManager

    @Published var transaction: Transaction

    // 自分の情報
    @Published var myUserId = ""
    @Published var myName = ""

    init(fireStoreTransactionManager: FireStoreTransactionManager,
         userDefaultsManager: UserDefaultsManager,
         transaction: Transaction) {
        self.fireStoreTransactionManager = fireStoreTransactionManager
        self.userDefaultsManager = userDefaultsManager
        self.transaction = transaction

        myUserId = self.userDefaultsManager.getUser()?.id ?? ""
        myName = self.userDefaultsManager.getUser()?.name ?? ""
    }

    func updateTransaction() async throws -> Result<Void, Error> {
        do {
            try await self.fireStoreTransactionManager.updateTransaction(transaction: transaction)
            // 成功した場合
            return .success(())
        } catch {
            // 失敗した場合
            print("updateTransaction関数内でエラー", error)
            return .failure(error)
        }
    }

}
