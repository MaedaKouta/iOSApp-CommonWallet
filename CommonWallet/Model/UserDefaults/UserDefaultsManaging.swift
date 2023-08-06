//
//  UserDefaultsManaging.swift
//  CommonWallet
//

import Foundation

protocol UserDefaultsManaging {

    var userDefaultsKey: UserDefaultsKey { get }

    func setUser(user: User)

    func setMyUserName(userName: String)

    func setPartnerName(name: String)

    func setPartnerShareNumber(shareNumber: String)

    func setOldestResolvedDate(date: Date?)

    func setMyIcon(path: String, imageData: Data)

    func setLaunchedVersion(version: String)

    func setPartnerInfo(partnerUserId: String?, partnerName: String, partnerShareNumber: String?, partnerIconPath: String, partnerIconData: Data)

    // MARK: - Getter
    // func getUser() -> User?

    func getMyUserId() -> String?

    func getMyUserName() -> String?

    func getMyShareNumber() -> String?

    func getPartnerUserId() -> String?

    func getPartnerName() -> String?

    func getPartnerShareNumber() -> String?

    func getOldestResolvedDate() -> Date?

    func getMyIconData() -> Data?
    func getMyIconPath() -> String?

    // MARK: Delete
    func clearUser()

}
