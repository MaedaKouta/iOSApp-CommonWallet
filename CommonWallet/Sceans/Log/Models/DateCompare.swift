//
//  PayInfoDivide.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/07.
//

import Foundation

class DateCompare {

    private let nowDate = Date()

    // 第一引数に、今月から何ヶ月戻った月と比較するかを取る
    func isEqualMonth(fromNowMonth: Int, compareDate: Date) -> Bool {
        guard let compareSourceDate = Calendar.current.date(byAdding: .month, value: -1*fromNowMonth, to: nowDate) else { return false }
        return Calendar.current.isDate(compareSourceDate, equalTo: compareDate, toGranularity: .month)
    }

    // 第一引数に、今月から何ヶ月戻った月と比較するかを取る
    func createStringMonthDate(fromNowMonth: Int) -> String {
        guard let date = Calendar.current.date(byAdding: .month, value: -1*fromNowMonth, to: nowDate) else { return "" }
        
        return Calendar.current.isDate(compareSourceDate, equalTo: compareDate, toGranularity: .month)
    }

}
