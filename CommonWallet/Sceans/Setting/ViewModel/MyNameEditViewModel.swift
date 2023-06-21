//
//  MyNameEditViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth

class MyNameEditViewModel: ObservableObject {

    private var userDefaultsManager: UserDefaultsManaging
    private var fireStoreUserManager: FireStoreUserManaging

    init(userDefaultsManager: UserDefaultsManaging, fireStoreUserManager: FireStoreUserManaging) {
        self.userDefaultsManager = userDefaultsManager
        self.fireStoreUserManager = fireStoreUserManager
    }

    /**
    自身のユーザー名を変更する. FireStoreとUserDefaultsに変更を加える.
     - Parameter newName: 自身の新しいユーザー名
     - Returns: 成功したかのBool値
     */
    internal func changeMyName(newName: String) async -> Bool {
        guard let myUserId = userDefaultsManager.getUser()?.id else {
            return false
        }
        do {
            try await fireStoreUserManager.putUserName(userId: myUserId, userName: newName)
            userDefaultsManager.setMyUserName(userName: newName)
            return true
        } catch {
            return false
        }
    }

}
