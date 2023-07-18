//
//  AuthError.swift
//  CommonWallet
//

import Foundation

enum AuthError: Error {
    case emptyUserId
    case other

    var localizedDescription: String {
        switch self {
        case .emptyUserId:
            return "User ID are empty."
        case .other:
            return "Auth Error, details unknown."
        }
    }
}
