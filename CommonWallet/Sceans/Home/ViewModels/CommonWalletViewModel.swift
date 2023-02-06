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
    @Published var unpaidCost = Int()

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
                self.unpaidCost = self.calculateUnPaidCost()
            } else {
                print(error as Any)
            }
        })
    }


    // 立替金額を計算する関数
    private func calculateUnPaidCost() -> Int {
        var cost: Int = 0
        for unPaidPayment in self.unpaidPayments {
            if unPaidPayment.isMyPay {
                cost += unPaidPayment.cost
            } else {
                cost -= unPaidPayment.cost
            }
        }
        return cost
    }

}
