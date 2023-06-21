//
//  AddPaymentViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/01.
//

import Foundation
import FirebaseAuth
import UIKit

class SettingViewModel: ObservableObject {

    private var userDefaultsManager: UserDefaultsManaging

    init(userDefaultsManager: UserDefaultsManaging) {
        self.userDefaultsManager = userDefaultsManager
    }

    /**
     パートナーと連携されているかどうか
     - Returns: 連携済みならtrue, 未連携ならfalse
     */
    internal func isConnectedPartner() -> Bool {
        if let _ = userDefaultsManager.getPartnerUserId() {
            return true
        } else {
            return false
        }
    }

}
