//
//  PaymentData.swift
//  CommonWallet
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Transaction: Codable, Identifiable {

    // TODO: @DocumentID付けときたい
    // @DocumentID var id: String? = UUID().uuidString
    var id: String = UUID().uuidString
    var creditorId: String? // 支払い者のID
    var debtorId: String? // 未払い者のID
    var title: String // タイトル
    var description: String // 詳細
    var amount: Int // 金額
    var createdAt: Date // 作成日時
    var resolvedAt: Date? // 精算日時

    enum CodingKeys: String, CodingKey {
        case id
        case creditorId
        case debtorId
        case title
        case description
        case amount
        case createdAt
        case resolvedAt
    }

}
