//
//  UnConnectPartnerViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth

class PartnerInfoViewModel: ObservableObject {

    private(set) var partnerShareNumber: String = ""
    private(set) var partnerName: String = ""
    private(set) var partnerModifiedName: String = ""

    private let fireStorePartnerManager = FireStorePartnerManager()
    private var userDefaultsManager = UserDefaultsManager()

    init() {
        partnerShareNumber = userDefaultsManager.getPartnerShareNumber()?.splitBy4Digits(betweenText: " - ") ?? ""
        partnerName = userDefaultsManager.getPartnerName() ?? ""
        partnerModifiedName = userDefaultsManager.getPartnerModifiedName() ?? ""
    }

    func deletePartner() async throws {
        guard let myUserId = userDefaultsManager.getUser()?.id,
            let partnerUserId = userDefaultsManager.getPartnerUserId() else {
            throw UserDefaultsError.emptyMyUserId
        }
        try await fireStorePartnerManager.deletePartner(myUserId: myUserId, partnerUserId: partnerUserId)
        userDefaultsManager.clearPartner()
    }

}
