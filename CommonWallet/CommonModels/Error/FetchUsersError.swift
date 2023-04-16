//
//  FetchUsersError.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/14.
//

import Foundation

enum FetchUsersError: Error {
    case emptyUserIds
    case emptyUserLastResolvedAt
    case emptyUserData

    var localizedDescription: String {
        switch self {
        case .emptyUserIds:
            return "User IDs are empty."
        case .emptyUserLastResolvedAt:
            return "User LastResolvedAt are empty."
        case .emptyUserData:
            return "User Data are empty."
        }
    }
}
