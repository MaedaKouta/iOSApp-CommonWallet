//
//  LogListsViewModel.swift
//  CommonWallet
//

import Foundation
import Parchment

class LogListsViewModel: ObservableObject {

    // 次ごとのTransactionを二次元配列で
    @Published var resolvedTransactionsByMonth: [[Transaction]] = [[Transaction]]()

    // 全てのTransaction
    private var resolvedTransactions: [Transaction] = [Transaction]()
    private let monthCount: Int
    private var fireStoreTransactionManager: FireStoreTransactionManager
    private var userDefaultsManager: UserDefaultsManager
    private var dateCompare: DateCompare

    init(fireStoreTransactionManager: FireStoreTransactionManager,
         userDefaultsManager: UserDefaultsManager,
         dateCompare: DateCompare
    ) {
        self.fireStoreTransactionManager = fireStoreTransactionManager
        self.userDefaultsManager = userDefaultsManager
        self.dateCompare = dateCompare
        monthCount = DateCalculator().calculateMonthsBetweenDates(startDate: userDefaultsManager.getOldestResolvedDate())
        initTransactionsByMonth()
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

    // ここをよく考える。
    // 毎回一撃で全部取得してたら重くなるよね...
    // でも、addSnapshotListnerで端末内にデータも入れてるから、想像以上に重くならないのか？
    /**
     トランザクションをまとめて全て取得する
     */
    func fetchTransactions() async {

        guard let myUserId = userDefaultsManager.getUser()?.id, let partnerUserId = userDefaultsManager.getPartnerUserId() else {
            return
        }

        fireStoreTransactionManager.fetchResolvedTransactions(myUserId: myUserId, partnerUserId: partnerUserId, completion: { transactions, error in

            if let error = error {
                print("fetchTransactions failed with error: \(error)")
                return
            }

            guard let transactions = transactions else { return }

            // トランザクションを時系列ごとに並べ替える
            let sortedTransactions = transactions.sorted(by: { (a, b) -> Bool in
                return a.createdAt > b.createdAt
            })
            // [Payments]を格納
            self.resolvedTransactions = sortedTransactions
            // 月ごとに[[Payments]]へ多次元配列へ分割
            self.transactionsDivideByMonth()
        })
    }

    /**
     トランザクションを月ごとに分割する
     */
    private func transactionsDivideByMonth() {

        // 二次元配列の中に全ての月数分の配列を用意する
        var newResolvedTransactionsByMonth: [[Transaction]] = Array(repeating: [], count: monthCount)

        for i in 0 ..< monthCount {
            // 多次元配列を扱うときは、appendでからの要素の追加を明示しないと、〇〇[i].appendが出来なかった
            for transaction in resolvedTransactions {
                // (monthCount-1)しないと、現在の月を除いた３ヶ月前のデータが取得される
                if self.dateCompare.checkSameMonth(monthsAgo: (monthCount-1)-i, compareDate: transaction.createdAt) {
                    newResolvedTransactionsByMonth[i].append(transaction)
                }
            }
        }

        self.resolvedTransactionsByMonth = newResolvedTransactionsByMonth
        print(self.resolvedTransactionsByMonth)
    }

}
