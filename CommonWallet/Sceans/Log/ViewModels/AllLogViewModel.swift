//
//  File.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import Foundation

class AllLogViewModel: ObservableObject {

    @Published var paidPayments = [PayInfo]()

    private var fireStorePaymentManager = FireStorePayInfoManager()
    private var userDefaultsManager = UserDefaultsManager()

    func featchPayments() {
        fireStorePaymentManager.fetchPaidPayInfo(completion: { payments, error in
            if let payments = payments {
                self.paidPayments = payments
            } else {
                print(error as Any)
            }
        })
    }

}
