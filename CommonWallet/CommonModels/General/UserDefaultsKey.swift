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
    let uid = "uid"
    let userName = "userName"
    let shareNumber = "shareNumber"
    let email = "email"
    let createdAt = "createdAt"
    let partnerUid = "partnerUid"
    let partnerName = "partnerName"
    let partnerShareNumber = "partnerShareNumber"

    // バージョン情報
    let launchedVersion = "launchedVersion"

}
