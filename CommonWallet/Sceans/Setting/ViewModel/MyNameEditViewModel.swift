//
//  MyNameEditViewModel.swift
//  CommonWallet
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
            userDefaultsManager.setMyUserName(userName: newName)
            return true
        } catch {
            return false
        }
    }

}
