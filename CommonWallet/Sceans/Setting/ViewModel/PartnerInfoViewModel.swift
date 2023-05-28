//
//  UnConnectPartnerViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import Foundation
import FirebaseAuth

class PartnerInfoViewModel: ObservableObject {

    @Published var isUnConnect: Bool = false

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

    func deletePartner() async {
        let result = await fireStorePartnerManager.deletePartner()
        switch result {
        case .success(_):
            DispatchQueue.main.async {
                self.isUnConnect = true
            }
        case .failure(let error):
            print("unConnectPartner failed: \(error.localizedDescription)")
        }
    }

    // 12桁の文字列を4桁ずつ" - "で区切る関数
    private func splitShareNumber(text: String) -> String {
        let textArray = text.splitInto(4)
        let splitShareNumber = textArray.joined(separator : " - ")
        return splitShareNumber
    }

}
