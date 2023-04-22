//
//  AddPaymentViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import Foundation
import FirebaseAuth

class AddTransactionViewModel: ObservableObject {

    private var fireStoreTransactionManager: FireStoreTransactionManager
    private var userDefaultsManager: UserDefaultsManager

    // ユーザー情報の監視用のPublished変数
    @Published var myUserId = ""
    @Published var myName = ""
    @Published var partnerUserId = ""
    @Published var partnerName = ""

    init(fireStoreTransactionManager: FireStoreTransactionManager,
         userDefaultsManager: UserDefaultsManager) {
        self.fireStoreTransactionManager = fireStoreTransactionManager
        self.userDefaultsManager = userDefaultsManager

        myUserId = self.userDefaultsManager.getUser()?.id ?? ""
        myName = self.userDefaultsManager.getUser()?.name ?? ""
        partnerName = self.userDefaultsManager.getPartnerName() ?? ""
        partnerUserId = self.userDefaultsManager.getPartnerUid() ?? ""
    }

    /// 新規トランザクション追加
    func addTransaction(creditorId: String, debtorId: String, title: String, description: String, amount: Int) async throws -> Result<Void, Error> {

        do {
            try await fireStoreTransactionManager.createTransaction(transactionId: UUID().uuidString, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount)
            // 成功した場合
            return .success(())
        } catch {
            // TODO: エラーハンドリング
            // 失敗した場合
            print("Transaction failed with error: \(error)")
            return .failure(error)
        }
    }

}
