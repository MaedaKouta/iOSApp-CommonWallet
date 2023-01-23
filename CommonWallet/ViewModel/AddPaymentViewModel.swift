//
//  AddPaymentViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import Foundation
import FirebaseAuth

class AddPaymentViewModel: ObservableObject {

    private let fireStorePaymentManager = FireStorePaymentManager()
    private let firebaseErrorManager = FirebaseErrorManager()

    func createPayment(title: String, memo: String, cost: Int, isMyPayment: Bool, complition: @escaping (Bool, String) -> Void) async {

        guard let uid = Auth.auth().currentUser?.uid else {
            complition(false, "uidが見つかりません。")
            return
        }

        do {
            try await fireStorePaymentManager.createPayment(userUid: uid, title: title, memo: memo, cost: cost, isMyPayment: isMyPayment)
            complition(true, "アカウント登録成功")
        } catch FirebaseErrorType.FireStore(let error) {
            let errorMessage = firebaseErrorManager.getFirestoreErrorMessage(error)
            complition(false, errorMessage)
        } catch {
            complition(false, "不明なエラー")
        }
    }
}
