//
//  UserDefaultsError.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/21.
//

import Foundation

enum UserDefaultsError: Error {
    case emptyUserIds

    var localizedDescription: String {
        switch self {
        case .emptyUserIds:
            return "User IDs From UserDefaults are empty."
        }
    }
}
