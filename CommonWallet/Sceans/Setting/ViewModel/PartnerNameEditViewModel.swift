//
//  ChangePartnerNameViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import Foundation
import FirebaseAuth

class PartnerNameEditViewModel: ObservableObject {

    internal let beforePartnerName: String
    private var userDefaultsManager = UserDefaultsManager()

    init() {
        beforePartnerName = userDefaultsManager.getPartnerModifiedName() ?? ""
    }

    func changePartnerName(newName: String) {
        userDefaultsManager.setPartnerModifiedName(name: newName)
    }

}
