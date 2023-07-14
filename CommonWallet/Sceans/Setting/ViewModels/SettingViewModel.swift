//
//  AddPaymentViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth
import UIKit

class SettingViewModel: ObservableObject {

    private var userDefaultsManager: UserDefaultsManaging

    init(userDefaultsManager: UserDefaultsManaging) {
        self.userDefaultsManager = userDefaultsManager
    }

}
