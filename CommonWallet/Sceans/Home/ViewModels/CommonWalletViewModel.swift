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
    @Published var payFromName = ""
    @Published var payToName = ""

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
        checkPayFromWitchPerson(unPaidPayment: cost)
        return abs(cost)
    }

    // 立替金額に応じて、どちらからどちらに支払えばよいか調べる関数
    private func checkPayFromWitchPerson(unPaidPayment: Int) {

        let partnerName: String = userDefaultsManager.getPartnerName() ?? ""
        let myName: String = userDefaultsManager.getUser()?.userName ?? ""

        // 立替額がマイナスなら"自分"から"相手"に支払い
        // 立替額がプラスなら"相手"から"自分"に支払い
        if unPaidPayment < 0 {
            payFromName = myName
            payToName = partnerName
        } else {
            payFromName = partnerName
            payToName = myName
        }
    }

}
