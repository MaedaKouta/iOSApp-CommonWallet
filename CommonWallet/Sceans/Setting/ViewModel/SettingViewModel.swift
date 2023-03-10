//
//  AddPaymentViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/01.
//

import Foundation
import FirebaseAuth

class SettingViewModel: ObservableObject {

    @Published var shareNumber = ""
    @Published var partnerName = ""
    private var userDefaultsManager = UserDefaultsManager()

    init() {
        shareNumber = splitShareNumber(text: userDefaultsManager.getShareNumber() ?? "")
        partnerName = userDefaultsManager.getPartnerName() ?? ""
    }

    // 12桁の文字列を4桁ずつ" - "で区切る関数
    private func splitShareNumber(text: String) -> String {
        let textArray = text.splitInto(4)
        let splitShareNumber = textArray.joined(separator : " - ")
        return splitShareNumber
    }

    func isConnectPartner() -> Bool {
        if let _ = userDefaultsManager.getPartnerUid() {
            return true
        } else {
            return false
        }
    }

    func reloadPartnerName() {
        partnerName = userDefaultsManager.getPartnerName() ?? ""
    }

}
