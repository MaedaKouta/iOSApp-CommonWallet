//
//  UserDefaultsKey.swift
//  CommonWallet
//

import Foundation

/**
 UserDefaultsのKey情報
 - Description
    - Myユーザー情報
        - userId
        - userName
        - shareNumber
        - email
        - myIconPath
        - myIconData
        - createdAt
        - oldestResolvedDate
    - Partnerユーザー情報
        - partnerUserId
        - partnerName
        - partnerIconPath
        - partnerIconData
        - partnerModifiedName
        - partnerShareNumber
    - サインイン情報
        - isSignedIn
    - バージョン情報
        - launchedVersion
 */
struct UserDefaultsKey {

    // Myユーザー情報
    let userId = "userId"
    let userName = "userName"
    let shareNumber = "shareNumber"
    let myIconPath = "myIconPath"
    let myIconData = "myIconData"
    let createdAt = "createdAt"
    // いらない？
    let oldestResolvedDate = "oldestResolvedDate"

    // Partnerユーザー情報
    let partnerUserId = "partnerUserId"
    let partnerName = "partnerName"
    let partnerIconPath = "partnerIconPath"
    let partnerIconData = "partnerIconData"
    let partnerShareNumber = "partnerShareNumber"

    // サインイン情報（いらない）
    let isSignedIn = "isSignedIn"

    // バージョン情報（現状いる？）
    let launchedVersion = "launchedVersion"

}
