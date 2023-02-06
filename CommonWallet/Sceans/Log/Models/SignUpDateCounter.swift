//
//  SignUpDateCounter.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import Foundation

class SignUpDateCounter {

    var userdefaultManager = UserDefaultsManager()

    func calculateSignUpMonth() -> Int {
        let createdAt = userdefaultManager.getUser()?.createdAt
        return 0
    }

    func monthsBetweenDates() -> Int {

        guard let startDate: Date = userdefaultManager.getUser()?.createdAt else {
            return 3
        }
        let endDate = Date()

        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: startDate, to: endDate)
        return components.month ?? 3
    }

}
