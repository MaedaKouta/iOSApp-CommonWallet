//
//  MyNameEditViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/06/06.
//

import Foundation
import FirebaseAuth

class MyNameEditViewModel: ObservableObject {

    internal let beforeMyName: String
    private var userDefaultsManager = UserDefaultsManager()
    private var fireStoreUserManager = FireStoreUserManager()
    private let myUserId: String
    private let myUserName: String

    init() {
        beforeMyName = userDefaultsManager.getUser()?.name ?? ""
        myUserId = userDefaultsManager.getUser()?.id ?? ""
        myUserName = userDefaultsManager.getUser()?.name ?? ""
    }

    func changeMyName(newName: String) async -> Bool {
        do {
            try await fireStoreUserManager.putUserName(userId: myUserId, userName: newName)
            userDefaultsManager.setPartnerModifiedName(name: newName)
            return true
        } catch {
            return false
        }
    }

}
