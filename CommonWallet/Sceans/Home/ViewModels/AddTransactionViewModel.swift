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

    @Published var myUserId = ""
    @Published var myName = ""
    @Published var partnerUserId = ""
    @Published var partnerName = ""

    init() {
        myUserId = userDefaultsManager.getUser()?.id ?? ""
        myName = userDefaultsManager.getUser()?.name ?? ""
        partnerName = userDefaultsManager.getPartnerName() ?? ""
        partnerUserId = userDefaultsManager.getPartnerUid() ?? ""
    }

    // TODO: 書き換え中
    func addTransaction(creditorId: String, debtorId: String, title: String, description: String, amount: Int) async throws -> Result<Void, Error> {

        do {
            // 非同期処理の完了を待つ
            try await fireStoreTransactionManager.createTransaction(transactionId: UUID().uuidString, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount)
            return .success(())
        } catch {
            // TODO: エラーハンドリング
            print("Transaction failed with error: \(error)")
            return .failure(error)
        }

    }

}
