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

    // サインイン情報
    let isSignedIn = "isSignedIn"

    // ユーザー情報
    let userUid = "userUid"
    let userName = "userName"
    let userShareNumber = "userShareNumber"
    let mailAdress = "mailAdress"
    let partnerUid = "partnerUid"
    let partnerName = "partnerName"

    // バージョン情報
    let launchedVersion = "launchedVersion"

}
