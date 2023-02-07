//
//  File.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import Foundation
import Parchment

class AllLogViewModel: ObservableObject {

    @Published var paidPayments = [PayInfo]()

    @Published var paidPaymentsByMonth: [[PayInfo]] = []
    @Published var pagingIndexItems: [PagingIndexItem] = []

    private var fireStorePaymentManager = FireStorePayInfoManager()
    private var userDefaultsManager = UserDefaultsManager()
    private var signUpDateCounter = SignUpDateCounter()
    private var payInfoDivide = PayInfoDivide()

    init() {
        createPagingItem()
        calculatePaidPaymentsByMonth()
    }

    func featchPayments() {
        fireStorePaymentManager.fetchPaidPayInfo(completion: { payments, error in
            if let payments = payments {
                self.paidPayments = payments
            } else {
                print(error as Any)
            }
        })
    }

    func calculatePaidPaymentsByMonth() {
        let monthCount = signUpDateCounter.calculateSignUpMonth()
        paidPaymentsByMonth = payInfoDivide.divideByMonth(monthCount: monthCount)
    }

    func createPagingItem() {
        let monthCount = signUpDateCounter.calculateSignUpMonth()
        for i in (0..<monthCount) {
            pagingIndexItems.append(PagingIndexItem(index: i, title: "◯月"))
        }
    }


}
