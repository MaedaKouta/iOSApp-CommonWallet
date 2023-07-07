//
//  AddPaymentViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth

class ConnectPartnerViewModel: ObservableObject {

    @Published var isConnect: Bool = false
    private let fireStorePartnerManager: FireStorePartnerManaging
    private let userDefaultsManager: UserDefaultsManaging

    init(fireStorePartnerManager: FireStorePartnerManaging, userDefaultsManager: UserDefaultsManaging) {
        self.fireStorePartnerManager = fireStorePartnerManager
        self.userDefaultsManager = userDefaultsManager
    }

    /**
     パートナーと連携し, 成功すればその値をUserDefaultsに保存
     - Parameters partnerShareNumber: 連携させるパートナーの共有番号
         */
    func connectPartner(partnerShareNumber: String) async throws {
        guard let myUserId = userDefaultsManager.getUser()?.id else {throw NSError()}
        let partner = try await fireStorePartnerManager.connectPartner(myUserId: myUserId, partnerShareNumber: partnerShareNumber)
        userDefaultsManager.setPartner(partner: partner)
    }

}
