//
//  File.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import Foundation
import Parchment

class AllLogViewModel: ObservableObject {

    @Published var selectedIndex: Int = Int()
    @Published var paidPayments: [PayInfo] = [PayInfo]()
    @Published var paidPaymentsByMonth: [[PayInfo]] = [[PayInfo]]()
    @Published var pagingIndexItems: [PagingIndexItem] = [PagingIndexItem]()

    private let monthCount: Int = CreateUserDateManager().monthsBetweenDates()

    private var fireStorePaymentManager = FireStorePayInfoManager()
    private let fireStorePayInfoManager = FireStorePayInfoManager()
    private var userDefaultsManager = UserDefaultsManager()
    private var createUserDateManager = CreateUserDateManager()
    private var dateCompare = DateCompare()

    init() {
        createSelectedIndex()
        initPaidPaymentsByMonth()
        createPagingItem()
        featchPayments()
    }

    // MARK: - イニシャライザ
    /*
     paidPaymentsByMonthの多次元配列がそのままの初期化だと、取得時にIndexOutOfRangeエラーが起こる
     空の配列を月数だけ格納しておくことでこれを回避する関数
     */
    private func initPaidPaymentsByMonth() {
        paidPaymentsByMonth = [[PayInfo]]()
        for _ in 0 ..< monthCount {
            paidPaymentsByMonth.append([PayInfo]())
        }
    }

    /*
     Parchmentの上タブの数を決めて、上タブのタイトルも設定する
     */
    private func createPagingItem() {
        for i in (0 ..< monthCount) {
            // (monthCount-1)しないと、現在の月を除いた３ヶ月前のデータが取得される
            let title = dateCompare.createStringMonthDate(fromNowMonth: (monthCount-1)-i)
            pagingIndexItems.append(PagingIndexItem(index: i, title: title))
        }
    }

    private func createSelectedIndex() {
        // IndexOutOfRangeしないように-1する
        selectedIndex = monthCount - 1
    }

    func featchPayments() {
        fireStorePaymentManager.fetchPaidPayInfo(completion: { payments, error in
            if let payments = payments {
                // [Payments]を取得
                self.paidPayments = payments
                // 月ごとに[[Payments]]へ多次元配列へ分割
                self.divideByMonth()
            } else {
                print(error as Any)
            }
        })
    }

    private func divideByMonth() {
        initPaidPaymentsByMonth()

        for i in 0 ..< monthCount {
            // 多次元配列を扱うときは、appendでからの要素の追加を明示しないと、〇〇[i].appendが出来なかった
            for payInfo in paidPayments {
                // (monthCount-1)しないと、現在の月を除いた３ヶ月前のデータが取得される
                if self.dateCompare.isEqualMonth(fromNowMonth: (monthCount-1)-i, compareDate: payInfo.createdAt.dateValue()) {
                    self.paidPaymentsByMonth[i].append(payInfo)
                }
            }
        }
    }

}
