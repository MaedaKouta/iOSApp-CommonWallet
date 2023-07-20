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
        let createdAt = Date()
        let partnerName = "パートナー"
        let sampleMyIconPath = "icon-sample-images/sample\(Int.random(in: 1...20)).jpeg"
        let sampleMyIconData = try await storageManager.download(path: sampleMyIconPath)
        let myShareNumber = try await shareNumberManager.createShareNumber()

        let samplePartnerIconPath = "icon-sample-images/initial-partner-icon.jpeg"
        let samplePartnerIconData = try await storageManager.download(path: samplePartnerIconPath)

        // FireStoreにアカウント登録
        try await fireStoreUserManager.createUser(userId: myUserId, userName: myUserName, iconPath: sampleMyIconPath, shareNumber: myShareNumber, createdAt: createdAt, partnerName: partnerName)

        // Userdefaultsに保存
        let user = User(
            id: myUserId,
            name: myUserName,
            shareNumber: myShareNumber,
            iconPath: sampleMyIconPath,
            iconData: sampleMyIconData,
            partnerUserId: nil,
            partnerName: partnerUserName,
            partnerShareNumber: nil
        )
        userDefaultsManager.setUser(user: user)
        userDefaultsManager.setPartnerIcon(path: samplePartnerIconPath, imageData: samplePartnerIconData)
        userDefaultsManager.setCreatedAt(createdAt)
    }

}
