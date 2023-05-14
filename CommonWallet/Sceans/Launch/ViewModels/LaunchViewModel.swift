//
//  LaunchViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/30.
//

import Foundation
import FirebaseAuth

class LaunchViewModel: ObservableObject {

    private var fireStoreTransactionManager = FireStoreTransactionManager()
    private var fireStoreUserManager = FireStoreUserManager()
    private var userDefaultsManager = UserDefaultsManager()

    func fetchOldestDate() async throws {
        fireStoreTransactionManager.fetchOldestDate(completion:  { oldestDate, error in
            if let error = error {
                print(error)
            }
            // 値がnilでない場合にuserDefaultsに保存しておく
            if let oldestDate = oldestDate {
                self.userDefaultsManager.setOldestResolvedDate(date: oldestDate)
            }
        })
    }

    // ここでUserInfoをfetchする
    // addSnapListernerだから、更新されるたびに自動でUserDefaultsが更新される
    func fetchUserInfo() async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("haven't Auth.auth().currentUser?.uid")
            return
        }
        self.fireStoreUserManager.fetchInfo(userId: userId, completion: { user, error in
            if error != nil {
                print("error")
                return
            }
            guard let user = user else {
                print("haven't user")
                return
            }
            self.userDefaultsManager.setUser(user: user)
        })
    }
}
