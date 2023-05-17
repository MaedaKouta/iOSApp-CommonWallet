//
//  InvalidValueError.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/05/14.
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
