//
//  UnConnectPartnerViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth

class PartnerInfoViewModel: ObservableObject {

    private(set) var partnerShareNumber: String = ""
    private(set) var partnerName: String = ""

    private let fireStorePartnerManager = FireStorePartnerManager()
    private var userDefaultsManager = UserDefaultsManager()
    private var storageManager = StorageManager()


    init() {
        partnerShareNumber = userDefaultsManager.getPartnerShareNumber()?.splitBy4Digits(betweenText: " - ") ?? ""
        partnerName = userDefaultsManager.getPartnerName() ?? ""
    }

    func deletePartner() async throws {
        // パートナー情報の削除
        guard let myUserId = userDefaultsManager.getMyUserId(),
            let partnerUserId = userDefaultsManager.getPartnerUserId() else {
            throw UserDefaultsError.emptyMyUserId
        }
        try await fireStorePartnerManager.deletePartner(myUserId: myUserId, partnerUserId: partnerUserId)
        userDefaultsManager.clearPartner()

        // パートナー情報の初期化
        let partnerUserName = "パートナー"
        let samplePartnerIconPath = "icon-sample-images/initial-partner-icon.jpeg"
        let samplePartnerIconData = try await storageManager.download(path: samplePartnerIconPath)
        let partner = Partner(userName: partnerUserName, iconPath: samplePartnerIconPath, iconData: samplePartnerIconData)
        userDefaultsManager.createPartner(partner: partner)
    }

}
