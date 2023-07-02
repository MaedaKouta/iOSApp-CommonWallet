//
//  LaunchViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth

class LaunchViewModel: ObservableObject {

    private var fireStoreTransactionManager = FireStoreTransactionManager()
    private var fireStoreUserManager = FireStoreUserManager()
    private var fireStorePartnerManager = FireStorePartnerManager()
    private var userDefaultsManager = UserDefaultsManager()

    func fetchOldestDate() async throws {
        guard let myUserId = userDefaultsManager.getUser()?.id,
              let partnerUserId = userDefaultsManager.getPartnerUserId() else {
            return
        }
        let oldestDate = try await fireStoreTransactionManager.fetchOldestDate(myUserId: myUserId, partnerUserId: partnerUserId)
        print("fetchOldestDate:", oldestDate)
        self.userDefaultsManager.setOldestResolvedDate(date: oldestDate)
    }

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
            self.userDefaultsManager.setUser(user: user)
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

            let partnerUserDefaultsName = self.userDefaultsManager.getPartnerName() ?? partner.userName
            self.userDefaultsManager.setPartner(
                userId: partner.userId,
                name: partner.userName,
                modifiedName: partnerUserDefaultsName,
                iconPath: partner.iconPath,
                iconData: partner.iconData,
                shareNumber: partner.shareNumber
            )
        })
    }

}
