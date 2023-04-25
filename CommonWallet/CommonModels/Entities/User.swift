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

    var name: String
    var email: String
    var shareNumber: String // 共有番号
    var createdAt: Date? // アカウント作成日時
    var lastResolvedAt: Date? // 前回の精算日時
    var previousResolvedAt: Date? // 前々回の精算日時
    var transactionIds: [String]? // 立替記録のIDリスト

    // パートナー
    var partnerUserId: String?
    var partnerName: String?
    var partnerShareNumber: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case shareNumber = "shareNumber"
        case createdAt = "createdAt"
        case lastResolvedAt = "lastResolvedAt"
        case previousResolvedAt = "previousResolvedAt"
        case transactionIds = "transactionIds"
        case partnerUserId = "partnerUserId"
        case partnerName = "partnerName"
        case partnerShareNumber = "partnerShareNumber"
    }

}
