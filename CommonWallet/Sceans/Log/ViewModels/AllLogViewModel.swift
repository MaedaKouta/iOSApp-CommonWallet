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
    @Published var paidPaymentsByMonth: [[PayInfo]] = [[PayInfo]]()
    @Published var pagingIndexItems: [PagingIndexItem] = [PagingIndexItem]()

    private var fireStorePaymentManager = FireStorePayInfoManager()
    private let fireStorePayInfoManager = FireStorePayInfoManager()
    private var userDefaultsManager = UserDefaultsManager()
    private var createUserDateManager = CreateUserDateManager()
    private var dateCompare = DateCompare()

    init() {
        createEmptyArray()
        createPagingItem()
        divideByMonth()
    }

    // MARK: - イニシャライザ
    /*
     paidPaymentsByMonthの多次元配列がそのままの初期化だと、取得時にIndexOutOfRangeエラーが起こる
     空の配列を月数だけ格納しておくことでこれを回避する関数
     */
    private func createEmptyArray() {
        let monthCount = createUserDateManager.monthsBetweenDates()
        for _ in 0 ..< monthCount {
            paidPaymentsByMonth.append([PayInfo]())
        }
    }

    /*
     Parchmentの上タブの数を決めて、上タブのタイトルも設定する
     */
    private func createPagingItem() {
        let monthCount = createUserDateManager.monthsBetweenDates()
        for i in (0..<monthCount) {
            pagingIndexItems.append(PagingIndexItem(index: i, title: "\(i)月"))
        }
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

    func divideByMonth() {
        let monthCount = createUserDateManager.monthsBetweenDates()
        fireStorePayInfoManager.fetchUnpaidPayInfo(completion: { payInfos, error in
            guard let payInfos = payInfos else { return }

            for i in 0 ..< monthCount {
                // 多次元配列を扱うときは、appendでからの要素の追加を明示しないと、〇〇[i].appendが出来なかった
                //self.paidPaymentsByMonth.append([PayInfo]())
                for payInfo in payInfos {
                    // (monthCount-1)しないと、現在の月を除いた３ヶ月前のデータが取得される
                    if self.dateCompare.isEqualMonth(fromNowMonth: (monthCount-1)-i, compareDate: payInfo.createdAt.dateValue()) {
                        self.paidPaymentsByMonth[i].append(payInfo)
                    }
                }
            }

        })
    }




}
