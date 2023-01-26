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

    func featchPaidPayments() {
        //fireStorePaymentManager.fetchPaidPayments()
    }
}
