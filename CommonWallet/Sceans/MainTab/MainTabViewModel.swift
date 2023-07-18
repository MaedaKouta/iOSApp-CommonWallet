//
//  MainTabViewModel.swift
//  CommonWallet
//

import Foundation
import SwiftUI

class MainTabViewModel: ObservableObject {
    private var fireStoreUserManager = FireStoreUserManager()
    private var fireStorePartnerManager = FireStorePartnerManager()
    private var userDefaultsManager = UserDefaultsManager()
    private var storageManager = StorageManager()


    @AppStorage(UserDefaultsKey().userId) private var myUserId: String?
    @AppStorage(UserDefaultsKey().partnerUserId) private var partnerUserId: String?

    /**
     FireStorageから自分の情報をリアルタイム取得
     */
    func realtimeFetchUserInfo() async {
        guard let myUserId = myUserId else { return }
        self.fireStoreUserManager.realtimeFetchInfo(userId: myUserId, completion: { user, error in

            if let error = error {
                print(error)
                return
            }

            guard let user = user else { return }
            self.userDefaultsManager.setUser(user: user)
        })
    }

    /**
     FireStorageからパートナーの情報をリアルタイム取得
     */
    func realtimeFetchPartnerInfo() async {
        guard let partnerUserId = partnerUserId else { return }
        if !partnerUserId.isEmpty {
            fireStorePartnerManager.realtimeFetchPartnerInfo(partnerUserId: partnerUserId, completion: { partner, error in

                if let error = error {
                    print(error)
                    return
                }

                guard let partner = partner else { return }
                print(partner)
                // もしパートナー側のpartnerShareNumberがなければ、連携解除されたってことだからこっちのUserDefaultsも連携解除する
                if (partner.partnerShareNumber ?? "").isEmpty {
                    // パートナー情報が無ければ、初期化
                    let partnerUserName = "パートナー"
                    let samplePartnerIconPath = "icon-sample-images/initial-partner-icon.jpeg"
                    let samplePartnerIconData = UIImage(named: "icon-initial-partner")?.jpegData(compressionQuality: 0.1)
                    let initPartner = Partner(userName: partnerUserName, iconPath: samplePartnerIconPath, iconData: samplePartnerIconData)
                    self.userDefaultsManager.createPartner(partner: initPartner)
                    return
                }
                self.userDefaultsManager.setPartner(partner: partner)
            })
        }
    }

}
