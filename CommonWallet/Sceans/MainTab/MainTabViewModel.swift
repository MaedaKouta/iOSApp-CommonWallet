//
//  MainTabViewModel.swift
//  CommonWallet
//

import Foundation

class MainTabViewModel: ObservableObject {
    private var authManager = AuthManager()
    private var shareNumberManager = ShareNumberManager()
    private var fireStoreTransactionManager = FireStoreTransactionManager()
    private var fireStoreUserManager = FireStoreUserManager()
    private var fireStorePartnerManager = FireStorePartnerManager()
    private var storageManager = StorageManager()
    private var userDefaultsManager = UserDefaultsManager()

    // ここでUserInfoをfetchする
    // addSnapListernerだから、更新されるたびに自動でUserDefaultsが更新される
    func realtimeFetchUserInfo() async {

        guard let myUserId = userDefaultsManager.getUser()?.id else { return }
        self.fireStoreUserManager.realtimeFetchInfo(userId: myUserId, completion: { [weak self] user, error in

            if let error = error {
                print(error)
                return
            }

            guard let user = user else { return }
            self?.userDefaultsManager.setUser(user: user)
        })
    }

    func realtimeFetchPartnerInfo() async {

        guard let myUserId = userDefaultsManager.getUser()?.id else { return }

        fireStorePartnerManager.realtimeFetchInfo(myUserId: myUserId, completion: { [weak self] partner, error in

            if let error = error {
                print(error)
                return
            }

            guard let partner = partner else { return }
            self?.userDefaultsManager.setPartner(partner: partner)
        })
    }

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
