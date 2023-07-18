//
//  FetchUsersError.swift
//  CommonWallet
//

import Foundation

enum FetchUsersError: Error {
    case emptyUserIds
    case emptyUserLastResolvedAt
    case emptyUserData
    case other

    var localizedDescription: String {
        switch self {
        case .emptyUserIds:
            return "User IDs are empty."
        case .emptyUserLastResolvedAt:
            return "User LastResolvedAt are empty."
        case .emptyUserData:
            return "User Data are empty."
        case .other:
            return "Fetch User Error, details unknown."
        }
    }
}
