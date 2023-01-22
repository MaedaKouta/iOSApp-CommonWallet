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
        UserDefaults.standard.set(user.uid, forKey: userDefaultsKey.uid)
        UserDefaults.standard.set(user.userName, forKey: userDefaultsKey.userName)
        UserDefaults.standard.set(user.mailAdress, forKey: userDefaultsKey.mailAdress)
    }

    mutating func getUser() -> User? {
        guard let userName = UserDefaults.standard.string(forKey: userDefaultsKey.userName),
              let mailAdress = UserDefaults.standard.string(forKey: userDefaultsKey.mailAdress),
              let uid = UserDefaults.standard.string(forKey: userDefaultsKey.uid)
        else {
            return nil
        }

        let user = User(userName: userName, mailAdress: mailAdress, uid: uid)
        return user
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
