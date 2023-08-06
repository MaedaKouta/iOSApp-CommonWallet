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
    private let imageProperty = ImageProperty()

    init(fireStorePartnerManager: FireStorePartnerManaging, userDefaultsManager: UserDefaultsManaging) {
        self.fireStorePartnerManager = fireStorePartnerManager
        self.userDefaultsManager = userDefaultsManager
    }

    /**
     パートナーと連携し, 成功すればその値をUserDefaultsに保存
     - Parameters partnerShareNumber: 連携させるパートナーの共有番号
         */
    func connectPartner(partnerShareNumber: String) async throws {
        guard let myUserId = Auth.auth().currentUser?.uid else {throw NSError()}
        let partnerUser = try await fireStorePartnerManager.connectPartner(myUserId: myUserId, partnerShareNumber: partnerShareNumber)
        userDefaultsManager.setPartnerInfo(
            partnerUserId: partnerUser.id,
            partnerName: partnerUser.name,
            partnerShareNumber: partnerUser.shareNumber,
            partnerIconPath: partnerUser.iconPath,
            partnerIconData: partnerUser.iconData ?? imageProperty.getIconNotFoundData()
        )
    }

}
