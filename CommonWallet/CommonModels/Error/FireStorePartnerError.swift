//
//  FireStorePartnerError.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/05/14.
//

import Foundation

enum FireStorePartnerError: Error {
    case failedPartnerInfoFound

    var localizedDescription: String {
        switch self {
        case .failedPartnerInfoFound:
            return "Failed Partner Info Found"
        }
    }
}
