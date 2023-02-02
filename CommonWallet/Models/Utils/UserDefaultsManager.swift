//
//  UserDefaultsManager.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/22.
//

import Foundation

struct UserDefaultsManager {

    private let userDefaultsKey = UserDefaultsKey()

    mutating func setUser(user: User) {
        UserDefaults.standard.set(user.myUid, forKey: userDefaultsKey.userUid)
        UserDefaults.standard.set(user.userName, forKey: userDefaultsKey.userName)
        UserDefaults.standard.set(user.mailAdress, forKey: userDefaultsKey.mailAdress)
        UserDefaults.standard.set(user.mailAdress, forKey: userDefaultsKey.mailAdress)
        UserDefaults.standard.set(user.myShareNumber, forKey: userDefaultsKey.userShareNumber)

        if let partnerUid = user.partnerUid {
            UserDefaults.standard.set(partnerUid, forKey: userDefaultsKey.partnerUid)
        }

        if let partnerName = user.partnerName {
            UserDefaults.standard.set(partnerName, forKey: userDefaultsKey.partnerName)
        }
    }

    mutating func clearUser() {
        UserDefaults.standard.set("", forKey: userDefaultsKey.userUid)
        UserDefaults.standard.set("", forKey: userDefaultsKey.userName)
        UserDefaults.standard.set("", forKey: userDefaultsKey.mailAdress)
        UserDefaults.standard.set("", forKey: userDefaultsKey.userShareNumber)
        UserDefaults.standard.set("", forKey: userDefaultsKey.partnerUid)
        UserDefaults.standard.set("", forKey: userDefaultsKey.partnerName)
    }

    mutating func getUser() -> User? {
        guard let userName = UserDefaults.standard.string(forKey: userDefaultsKey.userName),
              let mailAdress = UserDefaults.standard.string(forKey: userDefaultsKey.mailAdress),
              let uid = UserDefaults.standard.string(forKey: userDefaultsKey.userUid),
              let shareNumber = UserDefaults.standard.string(forKey: userDefaultsKey.userShareNumber)
        else {
            return nil
        }

        let partnerUid = UserDefaults.standard.string(forKey: userDefaultsKey.partnerUid)
        let partnerName = UserDefaults.standard.string(forKey: userDefaultsKey.partnerName)

        let user = User(userName: userName, mailAdress: mailAdress, myUid: uid, myShareNumber: shareNumber, partnerUid: partnerUid, partnerName: partnerName)
        return user
    }

    mutating func getShareNumber() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey.userShareNumber)
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
