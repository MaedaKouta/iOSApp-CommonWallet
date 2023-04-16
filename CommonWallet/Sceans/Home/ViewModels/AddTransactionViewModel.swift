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
    private let firebaseErrorManager = FirebaseErrorManager()
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


    func addTransaction(creditorId: String, debtorId: String, title: String, description: String, amount: Int, complition: @escaping (Bool, String) -> Void) async {

        do {
            try await fireStoreTransactionManager.createTransaction(transactionId: UUID().uuidString, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount)
            complition(true, "transaction追加成功")
        } catch FirebaseErrorType.FireStore(let error) {
            let errorMessage = firebaseErrorManager.getFirestoreErrorMessage(error)
            complition(false, errorMessage)
        } catch {
            complition(false, "不明なエラー")
        }
    }

    // TODO: 書き換え中
    func addTransaction2(creditorId: String, debtorId: String, title: String, description: String, amount: Int) async throws -> Bool {

        do {
            try await fireStoreTransactionManager.createTransaction(transactionId: UUID().uuidString, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount)
            return true
        } catch {
            // TODO: エラーハンドリング
            return false
        }

    }

}
