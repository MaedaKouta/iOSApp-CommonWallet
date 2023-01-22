//
//  UserDefaultsKey.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/22.
//

import Foundation

/*
 UserDefaultsのKeyを保存するだけのModel
 */
struct UserDefaultsKey {

    // ユーザー情報関係
    let isSignedIn = "isSignedIn"
    let userNameKey = "userName"
    let mailAdress = "mailAdress"
    let userCreatedAt = "userCreatedAt"

    // 端末情報関係
    let launchedVersionKey = "launchedVersion"

}
