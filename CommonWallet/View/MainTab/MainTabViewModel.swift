//
//  MainTabViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth
import SwiftUI

class MainTabViewModel: ObservableObject {

    private var fireStoreUserManager = FireStoreUserManager()
    private var fireStorePartnerManager = FireStorePartnerManager()
    private var userDefaultsManager = UserDefaultsManager()
    private var storageManager = StorageManager()
    private var imageProperty = ImageProperty()

    @AppStorage(UserDefaultsKey().partnerUserId) private var partnerUserId: String?

    /**
     FireStorageから自分の情報をリアルタイム取得
     */
    func realtimeFetchUserInfo() async {
        guard let myUserId = Auth.auth().currentUser?.uid else { return }
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
            fireStorePartnerManager.realtimeFetchPartnerInfo(partnerUserId: partnerUserId, completion: { partnerUser, error in

                if let error = error {
                    print(error)
                    return
                }

                guard let partnerUser = partnerUser else { return }
                // もしパートナー側のpartnerShareNumberがなければ、連携解除されたってことだからこっちのUserDefaultsも連携解除する
                if (partnerUser.partnerShareNumber ?? "").isEmpty {
                    // パートナー情報が無ければ、初期化
                    let partnerUserName = "パートナー"
                    let samplePartnerIconPath = "icon-sample-images/initial-partner-icon.jpeg"
                    let samplePartnerIconData = self.imageProperty.getIconInitialPartnerData()

                    self.userDefaultsManager.setPartnerInfo(
                        partnerUserId: nil,
                        partnerName: partnerUserName,
                        partnerShareNumber: nil,
                        partnerIconPath: samplePartnerIconPath,
                        partnerIconData: samplePartnerIconData
                    )
                    return
                }
                self.userDefaultsManager.setPartnerInfo(
                    partnerUserId: partnerUser.id,
                    partnerName: partnerUser.name,
                    partnerShareNumber: partnerUser.shareNumber,
                    partnerIconPath: partnerUser.iconPath,
                    partnerIconData: partnerUser.iconData ?? self.imageProperty.getIconNotFoundData()
                )
            })
        }
    }

}
