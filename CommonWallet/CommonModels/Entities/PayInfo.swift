//
//  PaymentData.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import Foundation
import Firebase

struct PayInfo: Codable, Identifiable {
    public var id: String = UUID().uuidString
    let userUid: String
    let title: String
    let cost: Int
    let isMyPay: Bool
    let createdAt: Timestamp
    var isFinished: Bool
}
