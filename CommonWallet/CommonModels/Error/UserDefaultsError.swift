//
//  UserDefaultsError.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/21.
//

import Foundation

enum UserDefaultsError: Error {
    case emptyUserIds
    case emptyMyUserId
    case emptyPartnerUserId
    case emptySomeValue

    var localizedDescription: String {
        switch self {
        case .emptyUserIds:
            return "User IDs From UserDefaults are empty."
        case .emptyMyUserId:
            return "My User ID From UserDefaults are empty."
        case .emptyPartnerUserId:
            return "Partner UserId From UserDefaults are empty."
        case .emptySomeValue:
            return "Some Value From UserDefaults are empty."
        }
    }
}
