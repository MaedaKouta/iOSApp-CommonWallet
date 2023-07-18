//
//  UserDefaultsManaging.swift
//  CommonWallet
//

import Foundation

protocol UserDefaultsManaging {

    var userDefaultsKey: UserDefaultsKey { get }

    func createUser(user: User)

    /**
     全てのユーザー情報をセットする（nilがここに入るとuserDefaultsにnilが入るから使用注意）
     */
    func setUser(user: User)

    /**
     パートナー作成時に必要
     */
    func createPartner(partner: Partner)

    func setPartner(partner: Partner)

    func setMyUserName(userName: String)

    func setPartnerName(name: String)

    func setPartnerShareNumber(shareNumber: String)

    func setOldestResolvedDate(date: Date?)

    func setMyIcon(path: String, imageData: Data)

    func setLaunchedVersion(version: String)

    // MARK: - Getter
    //func getUser() -> User?

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
    func clearPartner()


}
