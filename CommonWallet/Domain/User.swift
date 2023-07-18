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
    var id : String
    var name: String
    var shareNumber: String // 共有番号
    var iconPath: String // アイコンのパス情報
    var iconData: Data? // アイコンのパス情報
    var createdAt: Date? // アカウント作成日時
    var partnerUserId: String?
    var partnerName: String?

    // userDefaults専用
    var oldestResolvedDate: Date? // 精算の最も古い日時
    var partnerShareNumber: String?

    
}
