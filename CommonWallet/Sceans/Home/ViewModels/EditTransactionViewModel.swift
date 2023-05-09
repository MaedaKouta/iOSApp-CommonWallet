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
    @Published var beforeTransaction: Transaction
    @Published var selectedIndex: Int

    // 自分の情報
    @Published var myUserId: String
    @Published var myName: String
    @Published var partnerUserId: String
    @Published var partnerName: String

    init(fireStoreTransactionManager: FireStoreTransactionManager,
         userDefaultsManager: UserDefaultsManager,
         transaction: Transaction) {

        print("title", transaction.title)
        self.fireStoreTransactionManager = fireStoreTransactionManager
        self.userDefaultsManager = userDefaultsManager
        self.transaction = transaction
        self.beforeTransaction = transaction

        myUserId = self.userDefaultsManager.getUser()?.id ?? ""
        myName = self.userDefaultsManager.getUser()?.name ?? ""
        partnerName = self.userDefaultsManager.getPartnerName() ?? ""
        partnerUserId = self.userDefaultsManager.getPartnerUid() ?? ""

        // 立て替えた人 == 自分なら、selectedIndexを0にする
        if transaction.creditorId == self.userDefaultsManager.getUser()?.id {
            self.selectedIndex = 0
        } else {
            self.selectedIndex = 1
        }
        
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
