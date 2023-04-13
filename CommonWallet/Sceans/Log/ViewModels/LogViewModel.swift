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

        DispatchQueue.main.async { [weak self] in
            self?.lastResolvedTransactions = []
        }
        // UserからlastResolvedAtとpreviousResolvedAtの取得
        let lastResolvedAt = try await fireStoreUserManager.fetchLastResolvedAt(userId: myUserId)

        do {
            guard let transactions = try await fireStoreTransactionManager.fetchResolvedTransactions(userId: myUserId) else {
                return
            }
            let filteredTransactions = transactions.filter { $0.resolvedAt == lastResolvedAt }

            DispatchQueue.main.async { [weak self] in
                self?.lastResolvedTransactions = filteredTransactions
            }
        } catch {
            print(error)
        }
    }

    // TODO: ここ非同期にしたい
    func fetchPreviousResolvedAt() async throws {

        DispatchQueue.main.async { [weak self] in
            self?.previousResolvedTransactions = []
        }
        // UserからlastResolvedAtとpreviousResolvedAtの取得
        let previousResolved = try await fireStoreUserManager.fetchPreviousResolvedAt(userId: myUserId)

        do {
            guard let transactions = try await fireStoreTransactionManager.fetchResolvedTransactions(userId: myUserId) else {
                return
            }
            let filteredTransactions = transactions.filter { $0.resolvedAt == previousResolved }

            DispatchQueue.main.async { [weak self] in
                self?.previousResolvedTransactions = filteredTransactions
            }
        } catch {
            print(error)
        }
    }

}
