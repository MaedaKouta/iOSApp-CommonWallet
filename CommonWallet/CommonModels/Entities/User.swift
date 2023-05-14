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
    var oldestResolvedDate: Date? // 精算の最も古い日時

    // パートナー
    var partnerUserId: String?
    var partnerName: String?
    var partnerShareNumber: String?

}
