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

    func fetchLastResolvedAt() async throws {
        // UserからlastResolvedAtとpreviousResolvedAtの取得
        guard let lastResolvedAt = try await fireStoreUserManager.fetchLastResolvedAt(userId: myUserId) else {
            return
        }

        fireStoreTransactionManager.fetchLastResolvedTransactions(lastResolvedDate: lastResolvedAt, completion: { transactions, error in
            if let error = error {
                print(error)
            }

            guard let transactions = transactions else { return }
            self.lastResolvedTransactions = transactions
        })
    }

    func fetchPreviousResolvedAt() async throws {
        // UserからlastResolvedAtとpreviousResolvedAtの取得
        guard let previousResolved = try await fireStoreUserManager.fetchPreviousResolvedAt(userId: myUserId) else {
            return
        }

        fireStoreTransactionManager.fetchPreviousResolvedTransactions(previousResolvedDate: previousResolved, completion: { transactions, error in
            if let error = error {
                print(error)
            }

            guard let transactions = transactions else { return }
            self.previousResolvedTransactions = transactions
        })
    }

}
