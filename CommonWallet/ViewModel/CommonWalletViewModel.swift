//
//  CommonWalletViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import Foundation

class CommonWalletViewModel: ObservableObject {

    @Published var paidPayments = [PayInfo]()
    @Published var unpaidPayments = [PayInfo]()

    private var fireStorePaymentManager = FireStorePayInfoManager()

    func featchPayments() {
        fireStorePaymentManager.fetchPaidPayInfo(completion: { payments, error in
            if let payments = payments {
                self.paidPayments = payments
            } else {
                print(error as Any)
            }
        })

        fireStorePaymentManager.fetchUnpaidPayInfo(completion: { payments, error in
            if let payments = payments {
                self.unpaidPayments = payments
            } else {
                print(error as Any)
            }
        })
    }
}
