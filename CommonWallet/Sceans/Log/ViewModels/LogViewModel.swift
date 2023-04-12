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
    // TODO: lastResolvedTransactionsの初期化を関数が呼ばれるたびにやりたいけどできない。。。
//    func fetchLastResolvedAt() async throws {
//
//        lastResolvedTransactions = []
//        // UserからlastResolvedAtとpreviousResolvedAtの取得
//        let lastResolvedAt = try await fireStoreUserManager.fetchLastResolvedAt(userId: myUserId)
//
//        fireStoreTransactionManager.fetchResolvedTransactions(completion: { transactions, error in
//            if let transactions = transactions {
//                for transaction in transactions {
//                    if transaction.resolvedAt == lastResolvedAt {
//                        self.lastResolvedTransactions.append(transaction)
//                    }
//                }
//            } else {
//                print(error as Any)
//            }
//        })
//    }
    func fetchLastResolvedAt() async throws {
        lastResolvedTransactions = []
        // UserからlastResolvedAtとpreviousResolvedAtの取得
        let lastResolvedAt = try await fireStoreUserManager.fetchLastResolvedAt(userId: myUserId)

        do {
            let transactions = try await fireStoreTransactionManager.fetchResolvedTransactions()
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
        previousResolvedTransactions = [Transaction]()
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
