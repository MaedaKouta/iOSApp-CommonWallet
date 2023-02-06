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

    @Published var pagingItems = [
        PagingIndexItem(index: 0, title: "1月"),
        PagingIndexItem(index: 1, title: "2月"),
        PagingIndexItem(index: 2, title: "3月"),
        PagingIndexItem(index: 3, title: "4月"),
        PagingIndexItem(index: 4, title: "5月"),
        PagingIndexItem(index: 5, title: "6月"),
    ]

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
