//
//  UserDefaultsManager.swift
//  CommonWallet
//

import Foundation
import SwiftUI

struct UserDefaultsManager: UserDefaultsManaging {

    internal let userDefaultsKey = UserDefaultsKey()

    // MARK: - Setter
    func createUser(user: User) {
        // 非オプショナル
        UserDefaults.standard.set(user.id, forKey: userDefaultsKey.userId)
        UserDefaults.standard.set(user.name, forKey: userDefaultsKey.userName)
        UserDefaults.standard.set(user.iconPath, forKey: userDefaultsKey.myIconPath)
        UserDefaults.standard.set(user.shareNumber, forKey: userDefaultsKey.shareNumber)
        UserDefaults.standard.set(user.createdAt, forKey: userDefaultsKey.createdAt)
    }

    func createPartner(partner: Partner) {
        UserDefaults.standard.set(partner.userId, forKey: userDefaultsKey.partnerUserId)
        UserDefaults.standard.set(partner.userName, forKey: userDefaultsKey.partnerModifiedName)
        UserDefaults.standard.set(partner.iconPath, forKey: userDefaultsKey.partnerIconPath)
        UserDefaults.standard.set(partner.iconData, forKey: userDefaultsKey.partnerIconData)
        UserDefaults.standard.set(partner.shareNumber, forKey: userDefaultsKey.partnerShareNumber)
    }

    func setMyUserName(userName: String) {
        UserDefaults.standard.set(userName, forKey: userDefaultsKey.userName)
    }

    func setPartner(partner: Partner) {
        UserDefaults.standard.set(partner.userId, forKey: userDefaultsKey.partnerUserId)
        UserDefaults.standard.set(partner.userName, forKey: userDefaultsKey.partnerName)
        UserDefaults.standard.set(partner.userName, forKey: userDefaultsKey.partnerModifiedName)
        UserDefaults.standard.set(partner.iconPath, forKey: userDefaultsKey.partnerIconPath)
        UserDefaults.standard.set(partner.iconData, forKey: userDefaultsKey.partnerIconData)
        UserDefaults.standard.set(partner.shareNumber, forKey: userDefaultsKey.partnerShareNumber)
    }

    func setPartner(userId: String, name: String, modifiedName: String, iconPath: String, iconData: Data, shareNumber: String) {
        UserDefaults.standard.set(userId, forKey: userDefaultsKey.partnerUserId)
        UserDefaults.standard.set(name, forKey: userDefaultsKey.partnerName)
        UserDefaults.standard.set(modifiedName, forKey: userDefaultsKey.partnerModifiedName)
        UserDefaults.standard.set(iconPath, forKey: userDefaultsKey.partnerIconPath)
        UserDefaults.standard.set(iconData, forKey: userDefaultsKey.partnerIconData)
        UserDefaults.standard.set(shareNumber, forKey: userDefaultsKey.partnerShareNumber)
    }

    func setPartner(userId: String, name: String, modifiedName: String, shareNumber: String) {
        UserDefaults.standard.set(userId, forKey: userDefaultsKey.partnerUserId)
        UserDefaults.standard.set(name, forKey: userDefaultsKey.partnerName)
        UserDefaults.standard.set(modifiedName, forKey: userDefaultsKey.partnerModifiedName)
        UserDefaults.standard.set(shareNumber, forKey: userDefaultsKey.partnerShareNumber)
    }

    func setPartnerUserId(userId: String) {
        UserDefaults.standard.set(userId, forKey: userDefaultsKey.partnerUserId)
    }

    func setPartnerName(name: String) {
        UserDefaults.standard.set(name, forKey: userDefaultsKey.partnerName)
    }

    func setPartnerShareNumber(shareNumber: String) {
        UserDefaults.standard.set(shareNumber, forKey: userDefaultsKey.partnerShareNumber)
    }

    func setPartnerModifiedName(name: String) {
        UserDefaults.standard.set(name, forKey: userDefaultsKey.partnerModifiedName)
    }

    func setOldestResolvedDate(date: Date?) {
        UserDefaults.standard.set(date, forKey: userDefaultsKey.oldestResolvedDate)
    }

    func setMyIcon(path: String, imageData: Data) {
        UserDefaults.standard.set(path, forKey: userDefaultsKey.myIconPath)
        UserDefaults.standard.set(imageData, forKey: userDefaultsKey.myIconData)
    }

    func setPartnerIcon(path: String, imageData: Data) {
        UserDefaults.standard.set(path, forKey: userDefaultsKey.partnerIconPath)
        UserDefaults.standard.set(imageData, forKey: userDefaultsKey.partnerIconData)
    }

    func setIsSignedIn(isSignedIn: Bool) {
        UserDefaults.standard.set(isSignedIn, forKey: userDefaultsKey.isSignedIn)
    }

    func setLaunchedVersion(version: String) {
        UserDefaults.standard.set(version, forKey: userDefaultsKey.launchedVersion)
    }

    // MARK: - Getter
    func getUser() -> User? {
        guard let userName = UserDefaults.standard.string(forKey: userDefaultsKey.userName),
              let userId = UserDefaults.standard.string(forKey: userDefaultsKey.userId),
              let myIconPath = UserDefaults.standard.string(forKey: userDefaultsKey.myIconPath),
              let shareNumber = UserDefaults.standard.string(forKey: userDefaultsKey.shareNumber)
        else {
            return nil
        }

        let partnerUserId = UserDefaults.standard.string(forKey: userDefaultsKey.partnerUserId)
        let partnerName = UserDefaults.standard.string(forKey: userDefaultsKey.partnerName)
        let createdAt = UserDefaults.standard.object(forKey: userDefaultsKey.createdAt) as? Date

        let user = User(id: userId, name: userName, shareNumber: shareNumber, iconPath: myIconPath, createdAt: createdAt, partnerUserId: partnerUserId, partnerName: partnerName)
        return user
    }

    func getShareNumber() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.shareNumber)
    }

    func getShareNumber2() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.shareNumber)
    }

    func getPartnerUserId() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerUserId)
    }

    func getPartnerName() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerName)
    }

    func getPartnerModifiedName() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerModifiedName)
    }

    func getPartnerShareNumber() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerShareNumber)
    }

    func getOldestResolvedDate() -> Date? {
        return UserDefaults.standard.object(forKey: userDefaultsKey.oldestResolvedDate) as? Date
    }

    func getMyIconImageData() -> Data? {
        return UserDefaults.standard.data(forKey: userDefaultsKey.myIconData)
    }

    func getMyIconImagePath() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.myIconPath)
    }

    func getPartnerIconImageData() -> Data? {
        return UserDefaults.standard.data(forKey: userDefaultsKey.partnerIconData)
    }

    func getPartnerIconImagePath() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerIconPath)
    }

    func getIsSignedIn() -> Bool? {
        return UserDefaults.standard.bool(forKey: userDefaultsKey.isSignedIn)
    }

    func getLaunchedVersion() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.launchedVersion)
    }

    // MARK: Delete
    func clearUser() {
        // Myユーザー情報
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.userId)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.userName)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.shareNumber)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.myIconPath)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.myIconData)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.createdAt)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.oldestResolvedDate)
    }

    func clearPartner() {
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerUserId)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerName)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerIconPath)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerIconPath)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerModifiedName)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerShareNumber)
    }

}
