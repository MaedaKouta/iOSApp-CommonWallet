//
//  User.swift
//  CommonWallet
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {

    @DocumentID var id : String? = UUID().uuidString
    var name: String
    var email: String
    var shareNumber: String // 共有番号
    var iconPath: String // アイコンのパス情報
    var createdAt: Date? // アカウント作成日時
    var partnerUserId: String?
    var partnerName: String?

    // userDefaults専用
    var oldestResolvedDate: Date? // 精算の最も古い日時
    var partnerShareNumber: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case shareNumber
        case iconPath
        case createdAt
        case oldestResolvedDate
        case partnerUserId
        case partnerName
        case partnerShareNumber
    }

}
