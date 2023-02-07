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
    func divideByMonth(monthCount: Int) {

        guard let createdAt = userDefaultsManager.getUser()?.createdAt else { return }

        fireStorePayInfoManager.fetchUnpaidPayInfo(completion: { payInfos, error in

        })
        
    }

    // 第一引数に、今月から何ヶ月戻った月と比較するかを取る
    func isEqualMonth(returnFromNowMonth: Int, compareDate: Date) -> Bool {
        var compareSourceDate = Calendar.current.date(byAdding: .month, value: -1*returnFromNowMonth, to: nowDate)
        return Calendar.current.isDate(compareSourceDate, equalTo: compareDate, toGranularity: .month)
    }

}
