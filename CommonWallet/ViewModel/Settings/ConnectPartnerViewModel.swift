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

    func connectPartner(partnerShareNumber: String) async {

        let aaa = await fireStorePartnerManager.connectPartner(partnerShareNumber: partnerShareNumber)
        print("\(aaa)")

        DispatchQueue.main.async {  // 👈 メインスレッドで実行する
            self.isConnect = aaa
            print("\(aaa)")
        }
    }

}
