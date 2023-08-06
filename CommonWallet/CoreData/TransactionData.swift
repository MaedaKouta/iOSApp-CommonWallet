//
//  UserData.swift
//  CommonWallet
//

import Foundation
import SwiftUI
import Parchment

// environmentObjectにしている
final public class TransactionData: ObservableObject {

    private var fireStoreTransactionManager: FireStoreTransactionManager = FireStoreTransactionManager()
    private var userDefaultsManager: UserDefaultsManager = UserDefaultsManager()
    private var dateCompare: DateCompare = DateCompare()

    @AppStorage(UserDefaultsKey().userId) private var myUserId = String()
    @AppStorage(UserDefaultsKey().partnerUserId) private var partnerUserId = String()

    // ここだけaddSnapshotListenerでまとめて取得する
    // FireStoreのアクセス数を最小限にする運用で、これが楽だと思った
    // 精算済みと未清算で分けて取得するパターン → 精算した場合、精算済みと未清算両方が変更されるから取得が2回必要。まとめとくと1回だけでよい。
    // その分通信が重たくなるのは承知なので、使ってみて考えてみる
    // （ソート済み）
    @Published private(set) var transactions: [Transaction]  = [Transaction]()

    // MARK: - 未清算
    // 未清算のトランザクション一覧
    @Published private(set) var unResolvedTransactions: [Transaction]  = [Transaction]()
    // トランザクション合計値（"パートナー" - "自分" の値）
    @Published private(set) var unResolvedAmounts: Int = 0
    // 未清算の自分のトランザクション合計値
    @Published private(set) var unResolvedMyAmounts: Int = 0
    // 未清算のパートナーのトランザクション合計値
    @Published private(set) var unResolvedPartnerAmounts: Int = 0

    // MARK: - 清算
    // 精算済みのトランザクション一覧
    @Published private(set) var resolvedTransactions: [Transaction]  = [Transaction]()
    // 精算済みの中で最も古いトランザクションの日付
    @Published private(set) var oldestResolvedDate: Date?
    // 最も古いデータ〜現在の月数、最小値は3
    @Published private(set) var monthCount: Int = 3
    // 精算済みの月ごとのトランザクション
    @Published private(set) var resolvedTransactionsByMonth: [[Transaction]]  = [[Transaction]]()
    // 精算済みの月ごとのトランザクション合計値
    @Published private(set) var resolvedTransactionsAmountByMonth: [Int]  = [Int]()
    // 精算済みの月ごとのPagingIndexItem（[[2023/05], [2023/06], [2023/07]]みたいに入る）
    @Published private(set) var resolvedPagingIndexItems: [PagingIndexItem] = [PagingIndexItem]()
    // resolvedPagingIndexItemsの選択中のIndex（デフォルト最新月を選択された状態にする）
    @Published internal var selectedResolvedPagingIndex: Int = 2
    // このaddSnapShotListenerが何回呼ばれたか
    private var addSnapShotListenerCount: Int = 0

    init() {
        realtimeFetchTransactions()
    }

    private func realtimeFetchTransactions() {

        fireStoreTransactionManager.fetchTransactions(myUserId: myUserId, partnerUserId: partnerUserId, completion: { [weak self] transactions, error in

            if let error = error {
                print(error)
                return
            }

            guard let transactions = transactions else { return }

            // トランザクションを時系列ごとに並べ替える
            let sortedTransactions = transactions.sorted(by: { (a, b) -> Bool in
                return a.createdAt > b.createdAt
            })

            // トランザクションの値に代入
            self?.transactions = sortedTransactions

            // 未清算のトランザクションと精算済みのトランザクションに振り分ける
            self?.divideTransactions()

            // 未清算の全体・自分・パートナーの合計値を算出
            self?.calculateUnResolvedAmounts()

            // 最も古い精算済みの日付を取得
            self?.findOldestResolvedTransaction()

            // 最も古い精算済みの日付〜現在までの月数を算出
            self?.calculateMonthCount()

            // 精算済みの月ごとのトランザクション、月ごとの合計値を算出
            self?.resolvedTransactionDivideByMonth()

            // 精算済みの月ごとのPagingIndexItemを作成
            self?.createResolvedPagingIndexItems()

            // resolvedPagingIndexItemsの選択中のIndexを登録
            self?.createSelectedResolvedPagingIndex()

            self?.addSnapShotListenerCount += 1
        })
    }

    // MARK: 下記は順番にクロージャーの中で実行すること

    /**
     トランザクションから、未清算と精算のトランザクションを分ける
     - Description
     - 下記のグローバル変数を上書き
     - resolvedTransactions, resolvedTransactions
     */
    private func divideTransactions() {
        var newResolvedTransactions: [Transaction]  = [Transaction]()
        var newUnResolvedTransactions: [Transaction]  = [Transaction]()

        for transaction in transactions {
            if let resolvedAt = transaction.resolvedAt {
                newResolvedTransactions.append(transaction)
            } else {
                newUnResolvedTransactions.append(transaction)
            }
        }

        self.resolvedTransactions = newResolvedTransactions
        self.unResolvedTransactions = newUnResolvedTransactions
    }

    /**
     未清算の全体・自分・パートナーの合計値を算出
     - Description
     - 下記のグローバル変数を上書き
     - unResolvedMyAmounts, unResolvedPartnerAmounts
     */
    private func calculateUnResolvedAmounts() {
        var newUnResolvedMyAmounts = 0
        var newUnResolvedPartnerAmounts = 0
        var newUnResolvedAmounts = 0

        for unResolvedTransaction in unResolvedTransactions {
            if unResolvedTransaction.creditorId == myUserId {
                newUnResolvedMyAmounts += unResolvedTransaction.amount
            } else {
                newUnResolvedPartnerAmounts += unResolvedTransaction.amount
            }
        }
        newUnResolvedAmounts = newUnResolvedPartnerAmounts - newUnResolvedMyAmounts

        self.unResolvedAmounts = newUnResolvedAmounts
        self.unResolvedMyAmounts = newUnResolvedMyAmounts
        self.unResolvedPartnerAmounts = newUnResolvedPartnerAmounts
    }

    /**
     最も古い精算済みの日付を取得
     - Description
     - 下記のグローバル変数を上書き
     - oldestResolvedDate
     */
    private func findOldestResolvedTransaction() {
        if transactions.count > 0 {
            oldestResolvedDate = transactions.first?.createdAt
        } else {
            oldestResolvedDate = nil
        }
    }

    /**
     最も古い精算済みの日付〜現在までの月数を算出
     - Description
     - 下記のグローバル変数を上書き
     - oldestResolvedDate
     */
    private func calculateMonthCount() {
        monthCount = DateCalculator().calculateMonthsBetweenDates(startDate: self.oldestResolvedDate)
    }

    /**
     精算済みの月ごとのトランザクション、月ごとの合計値を算出
     - Description
     - 下記のグローバル変数を上書き
     - oldestResolvedDate
     */
    private func resolvedTransactionDivideByMonth() {

        var newResolvedTransactionsByMonth: [[Transaction]] = Array(repeating: [], count: monthCount)
        var newResolvedTransactionsAmountByMonth: [Int] = Array(repeating: 0, count: monthCount)

        for i in 0 ..< monthCount {

            // 多次元配列を扱うときは、appendでからの要素の追加を明示しないと、〇〇[i].appendが出来なかった
            // (monthCount-1)しないと、現在の月を除いた３ヶ月前のデータが取得される
            for transaction in resolvedTransactions where self.dateCompare.checkSameMonth(monthsAgo: (monthCount-1)-i, compareDate: transaction.createdAt) {
                newResolvedTransactionsByMonth[i].append(transaction)
                newResolvedTransactionsAmountByMonth[i] += transaction.amount
            }
        }

        self.resolvedTransactionsByMonth = newResolvedTransactionsByMonth
        self.resolvedTransactionsAmountByMonth = newResolvedTransactionsAmountByMonth
    }

    /**
     精算済みのParchmentの上タブの数を決め、タイトルも設定する
     - Description
     - 下記のグローバル変数を上書き
     - resolvedPagingIndexItems
     */
    private func createResolvedPagingIndexItems() {
        var newResolvedPagingIndexItems = [PagingIndexItem]()

        for i in (0 ..< monthCount) {
            // (monthCount-1)しないと、現在の月を除いた３ヶ月前のデータが取得される
            let title = dateCompare.getPreviousYearMonth(monthsAgo: (monthCount-1)-i)
            newResolvedPagingIndexItems.append(PagingIndexItem(index: i, title: title))
        }

        self.resolvedPagingIndexItems = newResolvedPagingIndexItems
    }

    /**
     値が書き換わって選択していたIndexがなくなったら、最新月を選択させる
     - Description
     - 下記のグローバル変数を上書き
     - selectedResolvedPagingIndex
     */
    private func createSelectedResolvedPagingIndex() {
        // IndexOutOfRangeしないように-1する
        // 初回の値受け取り時は、最新月を選択させる
        if addSnapShotListenerCount == 0 {
            self.selectedResolvedPagingIndex = self.monthCount - 1
        // 初回以外の値受け取りは、IndexOutOfRangeしかけたときだけ更新
        } else {
            if self.selectedResolvedPagingIndex > monthCount - 1 {
                self.selectedResolvedPagingIndex = self.monthCount - 1
            }
        }

    }
}
