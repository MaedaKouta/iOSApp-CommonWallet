//
//  FetchError.swift
//  CommonWallet
//

import Foundation

enum FetchTransactionsError: Error {
    case emptyTransactionIds
    case emptyTransactionData
    case documentDataNotFound
    case other

    var localizedDescription: String {
        switch self {
        case .emptyTransactionIds:
            return "Transaction IDs are empty."
        case .emptyTransactionData:
            return "Transaction Data are empty."
        case .documentDataNotFound:
            return "Document Data Not Found."
        case .other:
            return "Fetch Transactions Error, details unknown."
        }
    }
}
