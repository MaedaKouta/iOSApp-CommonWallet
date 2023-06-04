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
    let userId = "userId"
    let userName = "userName"
    let shareNumber = "shareNumber"
    let email = "email"
    let myIconImagePath = "myIconImagePath"
    let myIconImageData = "myIconImageData"
    let partnerIconImagePath = "partnerIconImagePath"
    let partnerIconImageData = "partnerIconImageData"
    let createdAt = "createdAt"
    let partnerUserId = "partnerUserId"
    let partnerName = "partnerName"
    let partnerModifiedName = "partnerModifiedName"
    let partnerShareNumber = "partnerShareNumber"
    let oldestResolvedDate = "oldestResolvedDate"

    // バージョン情報
    let launchedVersion = "launchedVersion"

}
