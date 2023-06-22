//
//  InvalidValueError.swift
//  CommonWallet
//

import Foundation

enum InvalidValueError: Error {
    case unexpectedNullValue
    case unexpectedBlankText

    var localizedDescription: String {
        switch self {
        case .unexpectedNullValue:
            return "unexpected null value"
        case .unexpectedBlankText:
            return "unexpected blank text"
        }
    }
}
