//
//  AccountViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import Foundation
import FirebaseAuth

class AccountViewModel: ObservableObject {

    @Published var userName = ""
    @Published var userEmail = ""
    private var userDefaultsManager = UserDefaultsManager()

    init() {
        userName = userDefaultsManager.getUser()?.name ?? ""
        userEmail = userDefaultsManager.getUser()?.email ?? ""
    }

}
