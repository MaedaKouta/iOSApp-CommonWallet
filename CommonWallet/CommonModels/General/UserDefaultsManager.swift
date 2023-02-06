//
//  UserDefaultsManager.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/22.
//

import Foundation

struct UserDefaultsManager {

    private let userDefaultsKey = UserDefaultsKey()

    // MARK: - Set
    mutating func setUser(user: User) {
        UserDefaults.standard.set(user.uid, forKey: userDefaultsKey.uid)
        UserDefaults.standard.set(user.userName, forKey: userDefaultsKey.userName)
        UserDefaults.standard.set(user.email, forKey: userDefaultsKey.email)
        UserDefaults.standard.set(user.shareNumber, forKey: userDefaultsKey.shareNumber)

        if let partnerUid = user.partnerUid {
            UserDefaults.standard.set(partnerUid, forKey: userDefaultsKey.partnerUid)
        }

        if let partnerName = user.partnerName {
            UserDefaults.standard.set(partnerName, forKey: userDefaultsKey.partnerName)
        }

        if let createdAt = user.createdAt {
            UserDefaults.standard.set(createdAt, forKey: userDefaultsKey.createdAt)
        }

    }

    mutating func setPartner(uid: String, name: String, shareNumber: String) {
        UserDefaults.standard.set(uid, forKey: userDefaultsKey.partnerUid)
        UserDefaults.standard.set(name, forKey: userDefaultsKey.partnerName)
        UserDefaults.standard.set(shareNumber, forKey: userDefaultsKey.partnerShareNumber)
    }

    mutating func setPartnerName(name: String) {
        UserDefaults.standard.set(name, forKey: userDefaultsKey.partnerName)
    }


    // MARK: - Get
    mutating func getUser() -> User? {
        guard let userName = UserDefaults.standard.string(forKey: userDefaultsKey.userName),
              let mailAdress = UserDefaults.standard.string(forKey: userDefaultsKey.email),
              let uid = UserDefaults.standard.string(forKey: userDefaultsKey.uid),
              let shareNumber = UserDefaults.standard.string(forKey: userDefaultsKey.shareNumber)
        else {
            return nil
        }

        let partnerUid = UserDefaults.standard.string(forKey: userDefaultsKey.partnerUid)
        let partnerName = UserDefaults.standard.string(forKey: userDefaultsKey.partnerName)
        let createdAt = UserDefaults.standard.object(forKey: userDefaultsKey.createdAt) as? Date

        let user = User(userName: userName, email: mailAdress, uid: uid, shareNumber: shareNumber, partnerUid: partnerUid, createdAt: createdAt, partnerName: partnerName)
        return user
    }

    mutating func getShareNumber() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.shareNumber)
    }

    mutating func getPartnerUid() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerUid)
    }

    mutating func getPartnerName() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerName)
    }

    mutating func getPartnerShareNumber() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.partnerShareNumber)
    }


    // MARK: Delete
    mutating func clearUser() {
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.uid)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.userName)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.email)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.shareNumber)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerUid)
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerName)
    }

    mutating func deletePartner() {
        UserDefaults.standard.set(nil, forKey: userDefaultsKey.partnerUid)
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
