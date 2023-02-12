//
//  AddPaymentViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import Foundation
import FirebaseAuth

class AddPayInfoViewModel: ObservableObject {

    private let fireStorePayInfoManager = FireStorePayInfoManager()
    private let firebaseErrorManager = FirebaseErrorManager()
    private var userDefaultsManager = UserDefaultsManager()
    @Published var myName = ""
    @Published var partnerName = ""

    init() {
        myName = userDefaultsManager.getUser()?.userName ?? ""
        partnerName = userDefaultsManager.getPartnerName() ?? ""
    }

    func createPayInfo(title: String, memo: String, cost: Int, isMyPay: Bool, complition: @escaping (Bool, String) -> Void) async {

        guard let uid = Auth.auth().currentUser?.uid else {
            complition(false, "uidが見つかりません。")
            return
        }

        do {
            try await fireStorePayInfoManager.createPayInfo(userUid: uid, title: title, memo: memo, cost: cost, isMyPay: isMyPay)
            complition(true, "アカウント登録成功")
        } catch FirebaseErrorType.FireStore(let error) {
            let errorMessage = firebaseErrorManager.getFirestoreErrorMessage(error)
            complition(false, errorMessage)
        } catch {
            complition(false, "不明なエラー")
        }
    }
}
