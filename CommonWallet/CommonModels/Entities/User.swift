//
//  User.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/22.
//

import Foundation
import Firebase

struct User: Codable, Identifiable {
    public var id: String = UUID().uuidString

    var userName: String
    var email: String
    var shareNumber: String
    var partnerUid: String?

    // UserDefaultだけ保存する変数
    var createdAt: Date?
    var partnerName: String?
    var partnerShareNumber: String?
}
