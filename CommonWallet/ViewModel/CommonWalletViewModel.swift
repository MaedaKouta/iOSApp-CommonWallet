//
//  CommonWalletViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import Foundation

class CommonWalletViewModel: ObservableObject {

    @Published var paidPayments = [Payment]()
    @Published var unpaidPayments = [Payment]()

    private var fireStorePaymentManager = FireStorePaymentManager()

    func featchPayments() {
        fireStorePaymentManager.fetchPaidPayments(completion: { payments, error in
            if let payments = payments {
                self.paidPayments = payments
            } else {
                print(error as Any)
            }
        })

        fireStorePaymentManager.fetchUnpaidPayments(completion: { payments, error in
            if let payments = payments {
                self.unpaidPayments = payments
            } else {
                print(error as Any)
            }
        })
    }
}
