//
//  PartnerNameEditViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth

class PartnerNameEditViewModel: ObservableObject {

    private var userDefaultsManager: UserDefaultsManaging
    private var fireStorePartnerManager: FireStorePartnerManaging

    init(userDefaultsManager: UserDefaultsManaging, fireStorePartnerManager: FireStorePartnerManaging) {
        self.userDefaultsManager = userDefaultsManager
        self.fireStorePartnerManager = fireStorePartnerManager
    }

    /**
    自身のユーザー名を変更する. FireStoreとUserDefaultsに変更を加える.
     - Parameter newName: 自身の新しいユーザー名
     - Returns: 成功したかのBool値
     */
    internal func changePartnerName(newName: String) async -> Bool {
        guard let myUserId = Auth.auth().currentUser?.uid else {
            return false
        }
        do {
            try await fireStorePartnerManager.putPartnerName(userId: myUserId, name: newName)
            userDefaultsManager.setPartnerName(name: newName)
            return true
        } catch {
            return false
        }
    }

}
