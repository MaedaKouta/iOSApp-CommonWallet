//
//  SignUpDateCounter.swift
//  CommonWallet
//

import Foundation

struct DateCalculator {

    private let calendar = Calendar.current

    /**
     現在の日付と指定された日付との間の月数を計算する
     - parameter startDate: 指定する日付（ここでは、UserdefaultsのOldestResolveDateを入れよう）
     - Returns: 月数を表す整数値
     - Note: 値が0でも最低3つの月を返す
     */
    func calculateMonthsBetweenDates(startDate: Date?) -> Int {
        let minimumMonths = 3
        let endDate = Date()

        guard let startDate = startDate else {
            // 開始日が存在しない場合は、最低3ヶ月を返す
            return minimumMonths
        }

        let components = calendar.dateComponents([.month], from: startDate, to: endDate)
        guard let month = components.month else {
            // 月の差分が取得できない場合も、最低3ヶ月を返す
            return minimumMonths
        }

        // 差を求めるだけだと8月から9月は、9-8で1ヶ月しかないことになる
        // 実際当月も含めて2ヶ月だから、+1しないといけない
        let monthsCount = month + 1
        return max(minimumMonths, monthsCount)
    }

}
