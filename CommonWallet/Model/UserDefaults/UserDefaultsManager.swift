//
//  UserDefaultsManager.swift
//  CommonWallet
//

import Foundation
import SwiftUI

struct UserDefaultsManager: UserDefaultsManaging {

    internal let userDefaultsKey = UserDefaultsKey()

    // MARK: - Setter
    /**
     userId以外の全てのユーザー情報をセットする
     nilがここに入るとuserDefaultsにnilが入るから使用注意
     */
    func setUser(user: User) {
        UserDefaults.standard.set(user.id, forKey: userDefaultsKey.userId)
        UserDefaults.standard.set(user.name, forKey: userDefaultsKey.userName)
        UserDefaults.standard.set(user.shareNumber, forKey: userDefaultsKey.shareNumber)
        UserDefaults.standard.set(user.iconPath, forKey: userDefaultsKey.myIconPath)
        UserDefaults.standard.set(user.iconData, forKey: userDefaultsKey.myIconData)
        UserDefaults.standard.set(user.partnerUserId, forKey: userDefaultsKey.partnerUserId)
        UserDefaults.standard.set(user.partnerName, forKey: userDefaultsKey.partnerName)
        UserDefaults.standard.set(user.partnerShareNumber, forKey: userDefaultsKey.partnerShareNumber)
    }

    func setCreatedAt(_ date: Date) {
        UserDefaults.standard.set(date, forKey: userDefaultsKey.createdAt)
    }

    func setMyUserName(userName: String) {
        UserDefaults.standard.set(userName, forKey: userDefaultsKey.userName)
    }

    func setPartnerName(name: String) {
        UserDefaults.standard.set(name, forKey: userDefaultsKey.partnerName)
    }

    func setPartnerShareNumber(shareNumber: String) {
        UserDefaults.standard.set(shareNumber, forKey: userDefaultsKey.partnerShareNumber)
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

    func setLaunchedVersion(version: String) {
        UserDefaults.standard.set(version, forKey: userDefaultsKey.launchedVersion)
    }

    // MARK: - Getter
    func getMyUserId() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.userId)
    }

    func getMyUserName() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.userName)
    }

    func getMyShareNumber() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.shareNumber)
    }

    func getPartnerUserId() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerUserId)
    }

    func getPartnerName() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerName)
    }

    func getPartnerShareNumber() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerShareNumber)
    }

    func getOldestResolvedDate() -> Date? {
        return UserDefaults.standard.object(forKey: userDefaultsKey.oldestResolvedDate) as? Date
    }

    func getMyIconData() -> Data? {
        return UserDefaults.standard.data(forKey: userDefaultsKey.myIconData)
    }

    func getMyIconPath() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.myIconPath)
    }

    // MARK: Delete
    func clearUser() {
        // Myユーザー情報
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.userId)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.userName)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.shareNumber)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.myIconPath)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.myIconData)

        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerUserId)
        UserDefaults.standard.set("パートナー", forKey: userDefaultsKey.partnerName)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerShareNumber)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.oldestResolvedDate)
    }

    func setPartnerInfo(partnerUserId: String?, partnerName: String, partnerShareNumber: String?, partnerIconPath: String, partnerIconData: Data) {
        UserDefaults.standard.set(partnerUserId, forKey: userDefaultsKey.partnerUserId)
        UserDefaults.standard.set(partnerName, forKey: userDefaultsKey.partnerName)
        UserDefaults.standard.set(partnerShareNumber, forKey: userDefaultsKey.partnerShareNumber)
        UserDefaults.standard.set(partnerIconPath, forKey: userDefaultsKey.partnerIconPath)
        UserDefaults.standard.set(partnerIconData, forKey: userDefaultsKey.partnerIconData)
    }

}
