//
//  PayInfoDivide.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/07.
//

import Foundation

class PayInfoDivide {

    private let fireStorePayInfoManager = FireStorePayInfoManager()
    private var userDefaultsManager = UserDefaultsManager()
    private let nowDate = Date()

    // 下のように使用している月数ごとにPayInfoを２重配列で格納する
    // [[初月のPayInfo], [次の月のPayInfo] ... ]
    func divideByMonth(monthCount: Int) -> [[PayInfo]] {

        var payInfoByMonth: [[PayInfo]] = []

        fireStorePayInfoManager.fetchUnpaidPayInfo(completion: { payInfos, error in

            guard let payInfos = payInfos else { return }

            for i in 0 ..< monthCount {
                for payInfo in payInfos {
                    if self.isEqualMonth(returnFromNowMonth: monthCount-i, compareDate: payInfo.createdAt.dateValue()) {
                        payInfoByMonth[i].append(payInfo)
                    }
                }
            }

        })

        return payInfoByMonth

    }

    // 第一引数に、今月から何ヶ月戻った月と比較するかを取る
    private func isEqualMonth(returnFromNowMonth: Int, compareDate: Date) -> Bool {
        guard let compareSourceDate = Calendar.current.date(byAdding: .month, value: -1*returnFromNowMonth, to: nowDate) else { return false }
        return Calendar.current.isDate(compareSourceDate, equalTo: compareDate, toGranularity: .month)
    }

}
