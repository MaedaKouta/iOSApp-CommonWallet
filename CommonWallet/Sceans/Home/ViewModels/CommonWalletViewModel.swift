//
//  CommonWalletViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import Foundation
import FirebaseFirestore

class CommonWalletViewModel: ObservableObject {

    @Published var resolvedTransactions = [Transaction]()
    @Published var unResolvedTransactions = [Transaction]()
    @Published var unResolvedAmount = Int()
    @Published var payFromName = ""
    @Published var payToName = ""
    
    @Published var myUserId = ""
    @Published var myName = ""
    @Published var partnerUserId = ""
    @Published var partnerName = ""
    
    private var fireStoreTransactionManager: FireStoreTransactionManager
    private var fireStoreUserManager: FireStoreUserManager
    private var userDefaultsManager: UserDefaultsManager
    
    init(fireStoreTransactionManager: FireStoreTransactionManager, fireStoreUserManager: FireStoreUserManager, userDefaultsManager: UserDefaultsManager) {

        self.fireStoreTransactionManager = fireStoreTransactionManager
        self.fireStoreUserManager = fireStoreUserManager
        self.userDefaultsManager = userDefaultsManager

        myUserId = self.userDefaultsManager.getUser()?.id ?? ""
        myName = self.userDefaultsManager.getUser()?.name ?? ""
        partnerName = self.userDefaultsManager.getPartnerName() ?? ""
        partnerUserId = self.userDefaultsManager.getPartnerUid() ?? ""
    }

    func getFireStoreTransactionManager() -> FireStoreTransactionManager {
        return self.fireStoreTransactionManager
    }

    func getFireStoreUserManager() -> FireStoreUserManager {
        return self.fireStoreUserManager
    }

    func getUserDefaultsManager() -> UserDefaultsManager {
        return self.userDefaultsManager
    }

    func fetchTransactions() async throws {

        // 精算済みのデータ取得・更新
        fireStoreTransactionManager.fetchUnResolvedTransactions(completion: { transactions, error in

            if let error = error {
                print("fetchTransactions failed with error: \(error)")
                return
            }
            self.unResolvedTransactions = []
            guard let transactions = transactions else { return }

            let sortedTransactions = transactions.sorted(by: { (a, b) -> Bool in
                return a.createdAt > b.createdAt
            })
            self.unResolvedTransactions = sortedTransactions

            // 〇〇から〇〇へ〇〇円を計算・アウトプットする関数
            self.calculateUnresolvedAmount()
        })

    }


    func deleteTransaction(transactionId: String) async throws {
        try await fireStoreTransactionManager.deleteTransaction(transactionId: transactionId)
    }

    /// 精算を完了させる関数
    func pushResolvedTransaction() async throws -> Result<Void, Error> {
        do {
            // 未精算のトランザクションに対して、resultTimeを登録
            let ids = unResolvedTransactions.map { $0.id }
            try await fireStoreTransactionManager.pushResolvedAt(transactionIds: ids, resolvedAt: Date())

            // 成功した場合
            return .success(())
        } catch {
            // 失敗した場合
            print("resolveTransaction関数内でエラー", error)
            return .failure(error)
        }

    }

    /// 未精算の取引から、ログインユーザーと相手ユーザーの支払金額を計算する関数
    private func calculateUnresolvedAmount() {
        // 取引合計金額を初期化
        var totalAmount: Int = 0
        // ログインユーザーのIDを取得
        guard let myUserId = userDefaultsManager.getUser()?.id else { return }

        // ログインユーザーと相手ユーザーの名前を取得
        // パートナーの名前は空があり得る(?)
        let partnerName = userDefaultsManager.getPartnerName() ?? ""
        let myName = userDefaultsManager.getUser()?.name ?? ""

        // 未精算の取引から、ログインユーザーと相手ユーザーの支払金額を計算
        for unResolvedTransaction in self.unResolvedTransactions {
            // 取引の債権者が自分かどうかを判定
            // 自分が債権者の場合、取引金額をtotalAmountに加算。そうでない場合は減算。
            let isCreditorMe = unResolvedTransaction.creditorId?.description == myUserId
            totalAmount += isCreditorMe ? unResolvedTransaction.amount : -unResolvedTransaction.amount
        }

        // 支払い元・支払い先と未精算金額を更新
        DispatchQueue.main.async {
            // 立替金額がマイナスの場合、自分が相手に支払う必要がある
            // 立替金額がプラスの場合、相手が自分に支払う必要がある
            self.payFromName = totalAmount < 0 ? myName : partnerName
            self.payToName = totalAmount < 0 ? partnerName : myName
            self.unResolvedAmount = abs(totalAmount)
        }
    }

}
