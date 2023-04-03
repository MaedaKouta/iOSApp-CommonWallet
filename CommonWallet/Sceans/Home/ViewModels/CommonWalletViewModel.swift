//
//  CommonWalletViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import Foundation

class CommonWalletViewModel: ObservableObject {

    @Published var resolvedTransactions = [Transaction]()
    @Published var unResolvedTransactions = [Transaction]()
    @Published var unResolvedAmount = Int()
    @Published var payFromName = ""
    @Published var payToName = ""

    private var fireStoreTransacationManager = FireStoreTransacationManager()
    private var userDefaultsManager = UserDefaultsManager()

    func featchTransactions() {
        fireStoreTransacationManager.fetchResolvedTransactions(completion: { transactions, error in
            if let transactions = transactions {
                self.resolvedTransactions = transactions
            } else {
                print(error as Any)
            }
        })

        fireStoreTransacationManager.fetchUnResolvedTransactions(completion: { transactions, error in
            if let transactions = transactions {
                self.unResolvedTransactions = transactions
                self.unResolvedAmount = self.calculateUnResolvedAmount()
            } else {
                print(error as Any)
            }
        })
    }

    // 立替金額を計算する関数
    private func calculateUnResolvedAmount() -> Int {
        var amount: Int = 0
        let myUserId = userDefaultsManager.getUser()?.id

        for unResolvedTransaction in self.unResolvedTransactions {
            if unResolvedTransaction.creditorId.description == myUserId {
                amount += unResolvedTransaction.amount
            } else {
                amount -= unResolvedTransaction.amount
            }
        }
        checkPayFromWitchPerson(unResolvedTransaction: amount)
        return abs(amount)
    }

    // 立替金額に応じて、どちらからどちらに支払えばよいか調べる関数
    private func checkPayFromWitchPerson(unResolvedTransaction: Int) {

        let partnerName: String = userDefaultsManager.getPartnerName() ?? ""
        let myName: String = userDefaultsManager.getUser()?.name ?? ""

        // 立替額がマイナスなら"自分"から"相手"に支払い
        // 立替額がプラスなら"相手"から"自分"に支払い
        if unResolvedTransaction < 0 {
            payFromName = myName
            payToName = partnerName
        } else {
            payFromName = partnerName
            payToName = myName
        }
    }

}
