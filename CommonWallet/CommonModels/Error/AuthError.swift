//
//  AuthError.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/16.
//

import Foundation

enum AuthError: Error {
    case emptyUserId

    var localizedDescription: String {
        switch self {
        case .emptyUserId:
            return "User ID are empty."
        }
    }
}
