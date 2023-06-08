//
//  UserDefaultsKey.swift
//  CommonWallet
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
    let myIconPath = "myIconPath"
    let myIconData = "myIconData"
    let partnerIconPath = "partnerIconPath"
    let partnerIconData = "partnerIconData"
    let createdAt = "createdAt"
    let partnerUserId = "partnerUserId"
    let partnerName = "partnerName"
    let partnerModifiedName = "partnerModifiedName"
    let partnerShareNumber = "partnerShareNumber"
    let oldestResolvedDate = "oldestResolvedDate"

    // バージョン情報
    let launchedVersion = "launchedVersion"

}
