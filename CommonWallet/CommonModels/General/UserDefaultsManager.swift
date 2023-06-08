//
//  UserDefaultsManager.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/22.
//

import Foundation
import SwiftUI

struct UserDefaultsManager {

    private let userDefaultsKey = UserDefaultsKey()

    // MARK: - Setter
    mutating func setUser(user: User) {
        UserDefaults.standard.set(user.id, forKey: userDefaultsKey.userId)
        UserDefaults.standard.set(user.name, forKey: userDefaultsKey.userName)
        UserDefaults.standard.set(user.email, forKey: userDefaultsKey.email)
        UserDefaults.standard.set(user.iconPath, forKey: userDefaultsKey.myIconPath)
        UserDefaults.standard.set(user.shareNumber, forKey: userDefaultsKey.shareNumber)

        if let partnerUserId = user.partnerUserId {
            UserDefaults.standard.set(partnerUserId, forKey: userDefaultsKey.partnerUserId)
        }

        if let partnerName = user.partnerName {
            UserDefaults.standard.set(partnerName, forKey: userDefaultsKey.partnerName)
        }

        if let createdAt = user.createdAt {
            UserDefaults.standard.set(createdAt, forKey: userDefaultsKey.createdAt)
        }
    }

    mutating func setMyUserName(userName: String) {
        UserDefaults.standard.set(userName, forKey: userDefaultsKey.userName)
    }

    mutating func setPartner(userId: String, name: String, iconPath: String, iconData: Data, shareNumber: String) {
        UserDefaults.standard.set(userId, forKey: userDefaultsKey.partnerUserId)
        UserDefaults.standard.set(name, forKey: userDefaultsKey.partnerName)
        UserDefaults.standard.set(name, forKey: userDefaultsKey.partnerModifiedName)
        UserDefaults.standard.set(iconPath, forKey: userDefaultsKey.partnerIconPath)
        UserDefaults.standard.set(iconData, forKey: userDefaultsKey.partnerIconData)
        UserDefaults.standard.set(shareNumber, forKey: userDefaultsKey.partnerShareNumber)
    }

    mutating func setPartner(userId: String, name: String, shareNumber: String) {
        UserDefaults.standard.set(userId, forKey: userDefaultsKey.partnerUserId)
        UserDefaults.standard.set(name, forKey: userDefaultsKey.partnerName)
        UserDefaults.standard.set(name, forKey: userDefaultsKey.partnerModifiedName)
        UserDefaults.standard.set(shareNumber, forKey: userDefaultsKey.partnerShareNumber)
    }

    mutating func setPartnerUserId(userId: String) {
        UserDefaults.standard.set(userId, forKey: userDefaultsKey.partnerUserId)
    }

    mutating func setPartnerName(name: String) {
        UserDefaults.standard.set(name, forKey: userDefaultsKey.partnerName)
    }

    mutating func setPartnerShareNumber(shareNumber: String) {
        UserDefaults.standard.set(shareNumber, forKey: userDefaultsKey.partnerShareNumber)
    }

    mutating func setPartnerModifiedName(name: String) {
        UserDefaults.standard.set(name, forKey: userDefaultsKey.partnerModifiedName)
    }

    mutating func setOldestResolvedDate(date: Date) {
        UserDefaults.standard.set(date, forKey: userDefaultsKey.oldestResolvedDate)
    }

    mutating func setMyIcon(path: String, imageData: Data) {
        UserDefaults.standard.set(path, forKey: userDefaultsKey.myIconPath)
        UserDefaults.standard.set(imageData, forKey: userDefaultsKey.myIconData)
    }

    mutating func setPartnerIcon(path: String, imageData: Data) {
        UserDefaults.standard.set(path, forKey: userDefaultsKey.partnerIconPath)
        UserDefaults.standard.set(imageData, forKey: userDefaultsKey.partnerIconData)
    }

    // MARK: - Getter
    mutating func getUser() -> User? {
        guard let userName = UserDefaults.standard.string(forKey: userDefaultsKey.userName),
              let email = UserDefaults.standard.string(forKey: userDefaultsKey.email),
              let userId = UserDefaults.standard.string(forKey: userDefaultsKey.userId),
              let myIconPath = UserDefaults.standard.string(forKey: userDefaultsKey.myIconPath),
              let shareNumber = UserDefaults.standard.string(forKey: userDefaultsKey.shareNumber)
        else {
            return nil
        }

        let partnerUserId = UserDefaults.standard.string(forKey: userDefaultsKey.partnerUserId)
        let partnerName = UserDefaults.standard.string(forKey: userDefaultsKey.partnerName)
        let createdAt = UserDefaults.standard.object(forKey: userDefaultsKey.createdAt) as? Date

        let user = User(id: userId, name: userName, email: email, shareNumber: shareNumber, iconPath: myIconPath, createdAt: createdAt, partnerUserId: partnerUserId, partnerName: partnerName)
        return user
    }

    mutating func getShareNumber() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.shareNumber)
    }

    mutating func getPartnerUserId() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerUserId)
    }

    mutating func getPartnerName() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerName)
    }

    mutating func getPartnerModifiedName() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerModifiedName)
    }

    mutating func getPartnerShareNumber() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerShareNumber)
    }

    mutating func getOldestResolvedDate() -> Date? {
        return UserDefaults.standard.object(forKey: userDefaultsKey.oldestResolvedDate) as? Date
    }

    mutating func getMyIconImageData() -> Data? {
        return UserDefaults.standard.data(forKey: userDefaultsKey.myIconData)
    }

    mutating func getMyIconImagePath() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.myIconPath)
    }

    mutating func getPartnerIconImageData() -> Data? {
        return UserDefaults.standard.data(forKey: userDefaultsKey.partnerIconData)
    }

    mutating func getPartnerIconImagePath() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerIconPath)
    }

    // MARK: Delete
    mutating func clearUser() {
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.userId)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.userName)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.email)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.shareNumber)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerUserId)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerName)
    }

    mutating func deletePartner() {
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerUserId)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerName)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerShareNumber)
    }

    var isSignedIn: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: userDefaultsKey.isSignedIn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultsKey.isSignedIn)
        }
    }

    var launchedVersion: String? {
        get {
            return UserDefaults.standard.string(forKey: userDefaultsKey.launchedVersion)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultsKey.launchedVersion)
        }
    }

}
