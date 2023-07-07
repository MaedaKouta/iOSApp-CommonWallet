//
//  FetchPartnerError.swift
//  CommonWallet
//

import Foundation

enum FetchPartnerError: Error {
    case emptyPartnerData
    case other

    var localizedDescription: String {
        switch self {
        case .emptyPartnerData:
            return "Partner Data are empty."
        case .other:
            return "Fetch Partner Error, details unknown."
        }
    }
}
