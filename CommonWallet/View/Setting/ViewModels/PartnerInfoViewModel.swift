//
//  UnConnectPartnerViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth

class PartnerInfoViewModel: ObservableObject {

    private let fireStorePartnerManager = FireStorePartnerManager()
    private var userDefaultsManager = UserDefaultsManager()
    private var storageManager = StorageManager()

    func deletePartner() async throws {
        // パートナー情報の削除
        guard let myUserId = userDefaultsManager.getMyUserId(),
            let partnerUserId = userDefaultsManager.getPartnerUserId() else {
            throw UserDefaultsError.emptyMyUserId
        }
        try await fireStorePartnerManager.deletePartner(myUserId: myUserId, partnerUserId: partnerUserId)

        // パートナー情報の初期化
        let partnerUserName = "パートナー"
        let samplePartnerIconPath = "icon-sample-images/initial-partner-icon.jpeg"
        let samplePartnerIconData = try await storageManager.download(path: samplePartnerIconPath)
        userDefaultsManager.setPartnerInfo(
            partnerUserId: nil,
            partnerName: partnerUserName,
            partnerShareNumber: nil,
            partnerIconPath: samplePartnerIconPath,
            partnerIconData: samplePartnerIconData
        )
    }

}
