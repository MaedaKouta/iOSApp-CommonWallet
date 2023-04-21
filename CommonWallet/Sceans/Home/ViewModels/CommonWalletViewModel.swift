//
//  CommonWalletViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import Foundation

class CommonWalletViewModel: ObservableObject {

    @Published var resolvedTransactions = [Transaction]()
    @Published var unResolvedTransactions = [Transaction]()
    @Published var unResolvedAmount = Int()
    @Published var payFromName = ""
    @Published var payToName = ""

    private var fireStoreTransactionManager = FireStoreTransactionManager()
    private var fireStoreUserManager = FireStoreUserManager()
    private var userDefaultsManager = UserDefaultsManager()

    func fetchTransactions() async throws -> Result<Void, Error> {

        // UserdefaultsからmyUserIdの取得
        guard let userId = userDefaultsManager.getUser()?.id else {
            throw UserDefaultsError.emptyUserIds
        }

        do {
            // 精算済みのデータ取得
            let result = try await fireStoreTransactionManager.fetchResolvedTransactions(userId: userId)
            DispatchQueue.main.async {
                self.resolvedTransactions = result ?? [Transaction]()
            }

            // 未精算のデータ取得
            let unResolvedResult = try await fireStoreTransactionManager.fetchUnResolvedTransactions(userId: userId)
            DispatchQueue.main.async {
                self.unResolvedTransactions = unResolvedResult ?? []
            }

            // 成功した場合
            return .success(())
        } catch {
            // TODO: エラーハンドリング
            // 失敗した場合
            print("fetchTransactions failed with error: \(error)")
            return .failure(error)
        }

    }

//    func fetchTransactions() {
//        fireStoreTransactionManager.fetchResolvedTransactions(completion: { transactions, error in
//            if let transactions = transactions {
//                self.resolvedTransactions = transactions
//            } else {
//                print(error as Any)
//            }
//        })
//
//        fireStoreTransactionManager.fetchUnResolvedTransactions(completion: { transactions, error in
//            if let transactions = transactions {
//                self.unResolvedTransactions = transactions
//                self.unResolvedAmount = self.calculateUnResolvedAmount()
//            } else {
//                print(error as Any)
//            }
//        })
//    }

    // 精算を完了させる関数
    func resolveTransaction() async throws {
        do {
            // 押下時間格納（resultTime）
            let resultTime = Date()
            //var tempDate: Date?
            let myUserId = userDefaultsManager.getUser()?.id ?? ""
            let partnerUserId = userDefaultsManager.getPartnerUid() ?? ""

            // TransactionのresultedAtにresultTime登録
            for unResolvedTransaction in unResolvedTransactions {
                try await fireStoreTransactionManager.addResolvedAt(transactionId: unResolvedTransaction.id, resolvedAt: resultTime)
            }

            // 自分と相手のUserのpreviousResolvedAtにlastResolvedAtをテンプ
            let tempDate = try await fireStoreUserManager.fetchLastResolvedAt(userId: myUserId)
            if let tempDate = tempDate {
                try await fireStoreUserManager.addPreviousResolvedAt(userId: myUserId, previousResolvedAt: tempDate)
                try await fireStoreUserManager.addPreviousResolvedAt(userId: partnerUserId, previousResolvedAt: tempDate)
            } else {
                print("resolveTransaction関数内でtempDateが空のまま処理")
            }

            // 自分と相手のUserのlastResolvedAtにresultTime登録
            try await fireStoreUserManager.addLastResolvedAt(userId: myUserId, lastResolvedAt: resultTime)
            try await fireStoreUserManager.addLastResolvedAt(userId: partnerUserId, lastResolvedAt: resultTime)
        } catch {
            print("精算を完了させる関数resolveTransactionでエラー", error)
        }

    }

    // 立替金額を計算する関数
    private func calculateUnResolvedAmount() -> Int {
        var amount: Int = 0
        let myUserId = userDefaultsManager.getUser()?.id

        for unResolvedTransaction in self.unResolvedTransactions {
            if unResolvedTransaction.creditorId.description == myUserId {
                amount += unResolvedTransaction.amount
            } else {
                amount -= unResolvedTransaction.amount
            }
        }
        checkPayFromWitchPerson(unResolvedTransaction: amount)
        return abs(amount)
    }

    // 立替金額に応じて、どちらからどちらに支払えばよいか調べる関数
    private func checkPayFromWitchPerson(unResolvedTransaction: Int) {

        let partnerName: String = userDefaultsManager.getPartnerName() ?? ""
        let myName: String = userDefaultsManager.getUser()?.name ?? ""

        // 立替額がマイナスなら"自分"から"相手"に支払い
        // 立替額がプラスなら"相手"から"自分"に支払い
        if unResolvedTransaction < 0 {
            payFromName = myName
            payToName = partnerName
        } else {
            payFromName = partnerName
            payToName = myName
        }
    }

}
