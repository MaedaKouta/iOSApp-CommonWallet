//
//  AuthError.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/16.
//

import Foundation

enum AuthError: Error {
    case emptyTransactionIds
    case emptyTransactionData

    var localizedDescription: String {
        switch self {
        case .emptyTransactionIds:
            return "Transaction IDs are empty."
        case .emptyTransactionData:
            return "Transaction Data are empty."
        }
    }
}
