//
//  LaunchViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/30.
//

import Foundation

class LaunchViewModel: ObservableObject {

    private var fireStoreTransactionManager = FireStoreTransactionManager()
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
}
