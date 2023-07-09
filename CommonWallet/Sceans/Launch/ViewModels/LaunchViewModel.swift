//
//  LaunchViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth

class LaunchViewModel: ObservableObject {

    private var authManager = AuthManager()
    private var shareNumberManager = ShareNumberManager()
    private var fireStoreTransactionManager = FireStoreTransactionManager()
    private var fireStoreUserManager = FireStoreUserManager()
    private var fireStorePartnerManager = FireStorePartnerManager()
    private var storageManager = StorageManager()
    private var userDefaultsManager = UserDefaultsManager()

    func createUser(myUserName: String, partnerUserName: String) async throws {
        // アカウント作成
        let authResult = try await authManager.signInAnonymously()

        // 自分の情報定義
        let myUserId = authResult.user.uid
        let sampleMyIconPath = "icon-sample-images/sample\(Int.random(in: 1...20)).jpeg"
        let samplePartnerIconPath = "icon-sample-images/initial-partner-icon.jpeg"
        let sampleMyIconData = try await storageManager.download(path: sampleMyIconPath)
        let samplePartnerIconData = try await storageManager.download(path: samplePartnerIconPath)
        let shareNumber = try await shareNumberManager.createShareNumber()

        // トランザクションにアカウント登録
        try await fireStoreUserManager.createUser(userId: myUserId, userName: myUserName, iconPath: sampleMyIconPath, shareNumber: shareNumber)

        // Userdefaultsに保存
        let user = User(id: myUserId, name: myUserName, shareNumber: shareNumber, iconPath: sampleMyIconPath, iconData: sampleMyIconData, createdAt: Date())
        let partner = Partner(userName: partnerUserName, iconPath: samplePartnerIconPath, iconData: samplePartnerIconData)
        userDefaultsManager.createUser(user: user)
        userDefaultsManager.createPartner(partner: partner)
    }

}
