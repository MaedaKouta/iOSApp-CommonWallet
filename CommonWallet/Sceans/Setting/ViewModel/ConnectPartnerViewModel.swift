//
//  AddPaymentViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
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
     - Returns: View(Section)
         */
    internal func connectPartner(partnerShareNumber: String) async -> Bool {
        do {
            let partner = try await fireStorePartnerManager.connectPartner(partnerShareNumber: partnerShareNumber)
            print(partner.iconPath)
            print(partner.shareNumber)
            print(partner.userId)
            print(partner.userName)
            userDefaultsManager.setPartner(partner: partner)
            return true
        } catch {
            return false
        }

    }

}
