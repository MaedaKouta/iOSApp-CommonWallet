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
    @Published var resolvedTransactions: [Transaction] = [Transaction]()
    @Published var resolvedTransactionsByMonth: [[Transaction]] = [[Transaction]]()
    @Published var pagingIndexItems: [PagingIndexItem] = [PagingIndexItem]()
    @Published var myUserId: String = ""

    private let monthCount: Int = CreateUserDateManager().monthsBetweenDates()

    private var fireStoreTransactionManager = FireStoreTransactionManager()
    private var userDefaultsManager = UserDefaultsManager()
    private var createUserDateManager = CreateUserDateManager()
    private var dateCompare = DateCompare()

    init() {
        createSelectedIndex()
        initTransactionsByMonth()
        createPagingItem()

        myUserId = self.userDefaultsManager.getUser()?.id ?? ""
    }

    // MARK: - イニシャライザ
    /*
     paidPaymentsByMonthの多次元配列がそのままの初期化だと、取得時にIndexOutOfRangeエラーが起こる
     空の配列を月数だけ格納しておくことでこれを回避する関数
     */
    private func initTransactionsByMonth() {
        resolvedTransactionsByMonth = [[Transaction]]()
        for _ in 0 ..< monthCount {
            resolvedTransactionsByMonth.append([Transaction]())
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

    func fetchTransactions() async throws {

        fireStoreTransactionManager.fetchResolvedTransactions(completion: { transactions, error in

            if let error = error {
                print("fetchTransactions failed with error: \(error)")
                return
            }

            guard let transactions = transactions else { return }
            // [Payments]を取得
            self.resolvedTransactions = transactions
            // 月ごとに[[Payments]]へ多次元配列へ分割
            self.transactionsDivideByMonth()
        })
    }

    private func transactionsDivideByMonth() {
        //initTransactionsByMonth()
        var newResolvedTransactionsByMonth: [[Transaction]] = Array(repeating: [], count: monthCount)

        for i in 0 ..< monthCount {
            // 多次元配列を扱うときは、appendでからの要素の追加を明示しないと、〇〇[i].appendが出来なかった
            for transaction in resolvedTransactions {
                // (monthCount-1)しないと、現在の月を除いた３ヶ月前のデータが取得される
                if self.dateCompare.isEqualMonth(fromNowMonth: (monthCount-1)-i, compareDate: transaction.createdAt) {
                    newResolvedTransactionsByMonth[i].append(transaction)
                }
            }
        }

        self.resolvedTransactionsByMonth = newResolvedTransactionsByMonth
        print(self.resolvedTransactionsByMonth)
    }

}
