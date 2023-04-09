//
//  LogViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/09.
//

import Foundation

class LogViewModel: ObservableObject {

    @Published var lastResolvedTransactions: [Transaction] = [Transaction]()
    @Published var previousResolvedTransactions: [Transaction] = [Transaction]()

    private var fireStoreTransactionManager = FireStoreTransactionManager()
    private var fireStoreUserManager = FireStoreUserManager()
    private var userDefaultsManager = UserDefaultsManager()

    private let myUserId: String
    private let partnerUserId: String

    init() {
        myUserId = userDefaultsManager.getUser()?.id ?? ""
        partnerUserId = userDefaultsManager.getPartnerUid() ?? ""
    }

    // TODO: ここ非同期にしたい
    func fetchLastResolvedAt() async throws {
        // UserからlastResolvedAtとpreviousResolvedAtの取得
        let lastResolvedAt = try await fireStoreUserManager.fetchLastResolvedAt(userId: myUserId)
        fireStoreTransactionManager.fetchResolvedTransactions(completion: { transactions, error in
            if let transactions = transactions {
                for transaction in transactions {
                    if transaction.resolvedAt == lastResolvedAt {
                        self.lastResolvedTransactions.append(transaction)
                    }
                }
            } else {
                print(error as Any)
            }
        })
    }

    // TODO: ここ非同期にしたい
    func fetchPreviousResolvedAt() async throws {
        let previousResolvedAt = try await fireStoreUserManager.fetchPreviousResolvedAt(userId: myUserId)
        fireStoreTransactionManager.fetchResolvedTransactions(completion: { transactions, error in
            if let transactions = transactions {
                for transaction in transactions {
                    if transaction.resolvedAt == previousResolvedAt {
                        self.previousResolvedTransactions.append(transaction)
                    }
                }
            } else {
                print(error as Any)
            }
        })
    }

}
