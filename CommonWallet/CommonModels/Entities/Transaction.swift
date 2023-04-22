//
//  PaymentData.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import Foundation
import Firebase

struct Transaction: Codable, Identifiable {
    public var id: String = UUID().uuidString

    var creditorId: String // 支払い者のID
    var debtorId: String // 未払い者のID
    var title: String // タイトル
    var description: String // 詳細
    var amount: Int // 金額
    var createdAt: Date // 作成日時
    var resolvedAt: Date? // 精算日時

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case creditorId = "creditorId"
        case debtorId = "debtorId"
        case title = "title"
        case description = "description"
        case amount = "amount"
        case createdAt = "createdAt"
        case resolvedAt = "resolvedAt"
    }

}
