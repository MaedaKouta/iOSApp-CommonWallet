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

    // ここでUserInfoをfetchする
    // addSnapListernerだから、更新されるたびに自動でUserDefaultsが更新される
    func fetchUserInfo() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("haven't Auth.auth().currentUser?.uid")
            return
        }
        self.fireStoreUserManager.realtimeFetchInfo(userId: userId, completion: { user, error in
            if error != nil {
                print("error")
                return
            }
            guard let user = user else {
                print("haven't user")
                return
            }
            self.userDefaultsManager.createUser(user: user)
        })
    }

    func fetchPartnerInfo() async {

        guard let myUserId = userDefaultsManager.getUser()?.id else {
            return
        }

        fireStorePartnerManager.realtimeFetchInfo(myUserId: myUserId, completion: { partner, error in
            if let error = error {
                return
            }

            guard let partner = partner else {
                print("haven't partner")
                return
            }

//            let partnerUserDefaultsName = self.userDefaultsManager.getPartnerName() ?? partner.userName
//            self.userDefaultsManager.setPartner(
//                userId: partner.userId,
//                name: partner.userName,
//                modifiedName: partnerUserDefaultsName,
//                iconPath: partner.iconPath,
//                iconData: partner.iconData,
//                shareNumber: partner.shareNumber
//            )
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
