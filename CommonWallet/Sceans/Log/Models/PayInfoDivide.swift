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

    //private let calendar = Calendar(identifier: .gregorian)
    private let nowDate = Date()
    private let dateFormat = DateFormatter.dateFormat(fromTemplate: .full, options: 0, locale: .current)

    // 下のように使用している月数ごとにPayInfoを２重配列で格納する
    // [[初月のPayInfo], [次の月のPayInfo] ... ]
    func divideByMonth(monthCount: Int) {
        
        guard let createdAt = userDefaultsManager.getUser()?.createdAt else { return }

        fireStorePayInfoManager.fetchUnpaidPayInfo(completion: { payInfos, error in

        })
        
    }

    func isEqualMonth(date1: Date, date2: Date) -> Bool {
        return Calendar.current.isDate(date1, equalTo: date2, toGranularity: .month)
    }

}
