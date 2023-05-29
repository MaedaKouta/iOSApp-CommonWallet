//
//  AddPaymentViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import Foundation
import FirebaseAuth

class ConnectPartnerViewModel: ObservableObject {

    @Published var isConnect: Bool = false
    private let fireStorePartnerManager = FireStorePartnerManager()

    func connectPartner(partnerShareNumber: String) async -> Bool {
        let result = await fireStorePartnerManager.connectPartner(partnerShareNumber: partnerShareNumber)
        switch result {
        case .success(_):
            //DispatchQueue.main.async {
                //self.isConnect = true
                return true
            //}
        case .failure(let error):
            print("connectPartner failed: \(error.localizedDescription)")
            return false
        }
    }

}
