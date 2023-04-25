//
//  PaymentData.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Transaction: Codable, Identifiable {
    public var id: String = UUID().uuidString

    var creditorId: String // 支払い者のID
    var debtorId: String // 未払い者のID
    var title: String // タイトル
    var description: String // 詳細
    var amount: Int // 金額
    var createdAt: Date // 作成日時
    var resolvedAt: Date? // 精算日時

//    init(dic: [String: Any]){
//        self.id = dic["id"] as? String ?? ""
//        self.creditorId = dic["creditorId"] as? String ?? ""
//        self.debtorId = dic["debtorId"] as? String ?? ""
//        self.title = dic["title"] as? String ?? ""
//        self.description = dic["description"] as? String ?? ""
//        self.amount = dic["amount"] as? Int ?? 0
//        self.createdAt = dic["createdAt"] as? Date ?? Date()
//    }

}
