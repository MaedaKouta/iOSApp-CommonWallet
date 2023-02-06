//
//  ChangePartnerNameViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import Foundation
import FirebaseAuth

class ChangePartnerNameViewModel: ObservableObject {

    @Published var beforePartnerName: String = ""
    private var userDefaultsManager = UserDefaultsManager()

    init() {
        beforePartnerName = userDefaultsManager.getPartnerName() ?? ""
    }

    func changePartnerName(newName: String) {
        userDefaultsManager.setPartnerName(name: newName)
    }

}
