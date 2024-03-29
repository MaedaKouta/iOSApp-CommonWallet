//
//  AddPaymentViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth

class AddTransactionViewModel: ObservableObject {

    private var fireStoreTransactionManager: FireStoreTransactionManager
    private var userDefaultsManager: UserDefaultsManager

    // ユーザー情報の監視用のPublished変数
    // 値が動的に変わる可能性がある
    @Published var myUserId = ""
    @Published var myName = ""
    @Published var partnerUserId = ""
    @Published var partnerName = ""

    init(fireStoreTransactionManager: FireStoreTransactionManager,
         userDefaultsManager: UserDefaultsManager) {
        self.fireStoreTransactionManager = fireStoreTransactionManager
        self.userDefaultsManager = userDefaultsManager

        myUserId = self.userDefaultsManager.getMyUserId() ?? ""
        myName = self.userDefaultsManager.getMyUserName() ?? ""
        partnerName = self.userDefaultsManager.getPartnerName() ?? ""
        partnerUserId = self.userDefaultsManager.getPartnerUserId() ?? ""
    }

    /// 新規トランザクション追加
    func addTransaction(myShareNumber: String, creditorId: String?, debtorId: String?, title: String, description: String, amount: Int) async throws -> Result<Void, Error> {

        do {
            // データベースで調べやすいように、myShareNumberをつける
            print(myShareNumber)
            let transactionId = myShareNumber + "-" + UUID().uuidString
            try await fireStoreTransactionManager.createTransaction(transactionId: transactionId, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount)
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
