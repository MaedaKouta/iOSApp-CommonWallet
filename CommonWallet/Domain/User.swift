//
//  User.swift
//  CommonWallet
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {

    // TODO: @DocumentID付けときたい
    // @DocumentID var id : String? = UUID().uuidString
    var id: String
    var name: String
    var shareNumber: String // 共有番号
    var iconPath: String // アイコンのパス情報
    var iconData: Data? // アイコンのパス情報

    // パートナー情報
    var partnerUserId: String?
    var partnerName: String?
    var partnerShareNumber: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shareNumber
        case iconPath
        case iconData
        case partnerUserId
        case partnerName
        case partnerShareNumber
    }
}
