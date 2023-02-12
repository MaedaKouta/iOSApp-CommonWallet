//
//  SignUpDateCounter.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import Foundation

class CreateUserDateManager {

    var userdefaultManager = UserDefaultsManager()

    func monthsBetweenDates() -> Int {
        // 値が0でも最低3つは返す
        let defaultReturn = 3

        guard let startDate: Date = userdefaultManager.getUser()?.createdAt else {
            return defaultReturn
        }
        let endDate = Date()

        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: startDate, to: endDate)
        return components.month ?? defaultReturn
    }

}