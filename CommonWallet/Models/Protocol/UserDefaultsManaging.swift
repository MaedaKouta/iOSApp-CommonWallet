//
//  UserDefaultsManaging.swift
//  CommonWallet
//

import Foundation

protocol UserDefaultsManaging {

    var userDefaultsKey: UserDefaultsKey { get }

    // MARK: - Setter
<<<<<<< HEAD:CommonWallet/Models/Protocol/UserDefaultsManaging.swift
    func setUser(user: User)
    func setMyUserName(userName: String)
=======
    func createUser(user: User)
    func createPartner(partner: Partner)
    func setUser(user: User)
>>>>>>> 91231b0 (fix: addSnapshotListenerの修正):CommonWallet/Models/UserDefaults/Protocol/UserDefaultsManaging.swift
    func setPartner(partner: Partner)
    func setMyUserName(userName: String)
    func setPartner(userId: String, name: String, modifiedName: String, iconPath: String, iconData: Data, shareNumber: String)
    func setPartner(userId: String, name: String, modifiedName: String, shareNumber: String)
    func setPartnerUserId(userId: String)
    func setPartnerName(name: String)
    func setPartnerShareNumber(shareNumber: String)
    func setPartnerModifiedName(name: String)
    func setOldestResolvedDate(date: Date?)
    func setMyIcon(path: String, imageData: Data)
    func setPartnerIcon(path: String, imageData: Data)
    func setIsSignedIn(isSignedIn: Bool)
    func setLaunchedVersion(version: String)

    // MARK: - Getter
    func getUser() -> User?
    func getShareNumber() -> String?
    func getPartnerUserId() -> String?
    func getPartnerName() -> String?
    func getPartnerModifiedName() -> String?
    func getPartnerShareNumber() -> String?
    func getOldestResolvedDate() -> Date?
    func getMyIconImageData() -> Data?
    func getMyIconImagePath() -> String?
    func getPartnerIconImageData() -> Data?
    func getPartnerIconImagePath() -> String?
    func getIsSignedIn() -> Bool?
    func getLaunchedVersion() -> String?

    // MARK: Delete
    func clearUser()
    func deletePartner()

}
