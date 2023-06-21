//
//  InvalidValueError.swift
//  CommonWallet
//

import Foundation

enum InvalidValueError: Error {
    case unexpectedNullValue

    var localizedDescription: String {
        switch self {
        case .unexpectedNullValue:
            return "unexpected null value"
        }
    }
}
