//
//  SignUpDateCounter.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import Foundation

class CreateUserDateManager {

    var userDefaultsManager = UserDefaultsManager()

    func monthsBetweenDates() -> Int {
        // 値が0でも最低3つは返す
        let defaultReturn = 3

        guard let startDate: Date = userDefaultsManager.getOldestResolvedDate() else {
            return defaultReturn
        }
        let endDate = Date()

        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: startDate, to: endDate)
        guard let month = components.month else {
            return defaultReturn
        }

        // 差を求めるだけだと8月から12月は、12-8で4ヶ月しかないことになる
        // 実際当月も含めて5ヶ月だから、+1しないといけない
        if (month+1) < defaultReturn {
            return defaultReturn
        } else {
            return (month+1)
        }

    }

}
