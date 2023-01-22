//
//  UserDefaultsManager.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/22.
//

import Foundation

extension UserDefaults {

    enum Key: String {
        case isSignedIn
        case userName
        case mailAdress
        case createdAt
    }

    var isSignedIn: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: Key.isSignedIn.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: Key.isSignedIn.rawValue)
        }
    }

    var userName: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.userName.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: Key.userName.rawValue)
        }
    }

    var mailAdress: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.mailAdress.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: Key.mailAdress.rawValue)
        }
    }

    var createdAt: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.createdAt.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: Key.createdAt.rawValue)
        }
    }

}
