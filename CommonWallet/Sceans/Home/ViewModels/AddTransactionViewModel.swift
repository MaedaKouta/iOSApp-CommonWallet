//
//  AddPaymentViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import Foundation
import FirebaseAuth

class AddTransactionViewModel: ObservableObject {

    private let fireStoreTransactionManager = FireStoreTransactionManager()
    private var userDefaultsManager = UserDefaultsManager()

    // ユーザー情報の監視用のPublished変数
    @Published var myUserId = ""
    @Published var myName = ""
    @Published var partnerUserId = ""
    @Published var partnerName = ""

    init() {
        // ユーザー情報の設定
        myUserId = userDefaultsManager.getUser()?.id ?? ""
        myName = userDefaultsManager.getUser()?.name ?? ""
        partnerName = userDefaultsManager.getPartnerName() ?? ""
        partnerUserId = userDefaultsManager.getPartnerUid() ?? ""
    }

    // TODO: 書き換え中
    // 新規トランザクション追加
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
