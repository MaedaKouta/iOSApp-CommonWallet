//
//  UserDefaultsError.swift
//  CommonWallet
//

import Foundation

enum UserDefaultsError: Error {
    case emptyUserIds
    case emptyMyUserId
    case emptyMyIcon
    case emptyPartnerUserId
    case emptySomeValue
    case emptyPartnerIcon
    case other

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
        case .emptyMyIcon:
            return "My Icon From UserDefaults are empty."
        case .emptyPartnerIcon:
            return "Partner Icon From UserDefaults are empty."
        case .other:
            return "Fetch Partner Error, details unknown."
        }
    }
}
