//
//  File.swift
//  CommonWallet
//

import Foundation
import Parchment

class AllLogViewModel: ObservableObject {

    @Published var selectedIndex: Int = Int()
    @Published var pagingIndexItems: [PagingIndexItem] = [PagingIndexItem]()

    private let monthCount: Int
    private var userDefaultsManager: UserDefaultsManager
    private var dateCalculator: DateCalculator
    private var dateCompare: DateCompare

    init(userDefaultsManager: UserDefaultsManager,
         dateCalculator: DateCalculator,
         dateCompare: DateCompare) {
        self.userDefaultsManager = userDefaultsManager
        self.dateCalculator = dateCalculator
        self.dateCompare = dateCompare
        // userDefaultsのOldestResolvedDateは、毎回起動するたびにセットしている
        monthCount = dateCalculator.calculateMonthsBetweenDates(startDate: userDefaultsManager.getOldestResolvedDate())
        createSelectedIndex()
        createPagingItem()
    }

    // MARK: - イニシャライザ（呼び出す順番守る）
    /**
     Parchmentの上タブの数を決め、タイトルも設定する
     - Description
     - [[2023/05], [2023/06], [2023/07]]みたいに入る
     */
    private func createPagingItem() {
        for i in (0 ..< monthCount) {
            // (monthCount-1)しないと、現在の月を除いた３ヶ月前のデータが取得される
            let title = dateCompare.getPreviousYearMonth(monthsAgo: (monthCount-1)-i)
            pagingIndexItems.append(PagingIndexItem(index: i, title: title))
        }
    }

    /*
     デフォルトで最新の月を選択された状態にする
     */
    private func createSelectedIndex() {
        // IndexOutOfRangeしないように-1する
        selectedIndex = monthCount - 1
    }

}
