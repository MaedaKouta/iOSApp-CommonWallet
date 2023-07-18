//
//  PayInfoDivide.swift
//  CommonWallet
//

import Foundation

struct DateCompare {

    private let currentDate = Date()
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setTemplate(.yearMonth)
        return formatter
    }()

    /**
     指定された月数の前の月と比較対象の日付が同じ月かどうかを確認する
     - Parameter monthsAgo : 現在から何ヶ月前の月と比較するかを表す整数値
     - Parameter compareDate : 比較対象の日付
     - returns: 比較結果を示すブール値
     */
    func checkSameMonth(monthsAgo: Int, compareDate: Date) -> Bool {

        // 比較元の日付を計算
        guard let compareSourceDate = calendar.date(byAdding: .month, value: -monthsAgo, to: currentDate) else {
            return false
        }

        // 月の粒度で比較
        return calendar.isDate(compareSourceDate, equalTo: compareDate, toGranularity: .month)
    }

    /**
     指定された月数だけ前の月を取得する関数
     - Parameter monthAgo : 今日から何ヶ月前の月を取得したいか、をInt型で指定
     - returns: 指定された月数だけ前の月を表す年と月を`yyyy/MM`形式の文字列で返す
     */
    func getPreviousYearMonth(monthsAgo: Int) -> String {

        // 指定された月数だけ前の月を計算
        guard let previousYearMonth = calendar.date(byAdding: .month, value: -monthsAgo, to: currentDate) else {
            return "Error: Failed to calculate previous year and month."
        }

        // 月の値を文字列に変換して返す
        return dateFormatter.string(from: previousYearMonth)
    }

}
