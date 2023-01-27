//
//  User.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/22.
//

import Foundation
import Firebase

/*
   Userデータの受け渡しだけに使う構造体
 */
struct User {
    var userName: String
    var mailAdress: String
    var myUid: String
    var partnerUid: String?
    var partnerName: String?
}
