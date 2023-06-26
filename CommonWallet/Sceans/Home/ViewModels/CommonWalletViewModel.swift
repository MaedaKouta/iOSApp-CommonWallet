//
//  CommonWalletViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseFirestore
import SwiftUI

class CommonWalletViewModel: ObservableObject {

    @Published var resolvedTransactions = [Transaction]()
    @Published var unResolvedTransactions = [Transaction]()

    @Published var unResolvedAmount = Int()
    @Published var myUnResolvedAmount = Int()
    @Published var partnerUnResolvedAmount = Int()
    @Published var payFromName = String()
    @Published var payToName = String()
    
    private var fireStoreTransactionManager: FireStoreTransactionManager
    private var fireStoreUserManager: FireStoreUserManager

    @AppStorage(UserDefaultsKey().userId) private var myUserId = String()
    @AppStorage(UserDefaultsKey().userName) private var myUserName = String()
    @AppStorage(UserDefaultsKey().partnerModifiedName) private var partnerModifiedName = String()

    init(fireStoreTransactionManager: FireStoreTransactionManager, fireStoreUserManager: FireStoreUserManager) {
        self.fireStoreTransactionManager = fireStoreTransactionManager
        self.fireStoreUserManager = fireStoreUserManager
    }

    /**
     addSnapShotでリアルタイムにトランザクションを取得する
     - parameter myUserId: 自分のユーザーID
     - parameter partnerUserId: パートナーのユーザーID
     */
    func realtimeFetchTransactions(myUserId: String, partnerUserId: String) async throws {
        // 精算済みのデータ取得・更新
        fireStoreTransactionManager.fetchUnResolvedTransactions(myUserId: myUserId, partnerUserId: partnerUserId, completion: { [weak self] transactions, error in

            if let error = error {
                print("fetchTransactions failed with error: \(error)")
                return
            }
            self?.unResolvedTransactions = []
            guard let transactions = transactions else { return }

            // トランザクションを時系列ごとに並べ替える
            let sortedTransactions = transactions.sorted(by: { (a, b) -> Bool in
                return a.createdAt > b.createdAt
            })
            self?.unResolvedTransactions = sortedTransactions

            // 〇〇から〇〇へ〇〇円を計算・アウトプットする関数
            self?.calculateUnresolvedAmount()
        })

    }

    /**
     指定したトランザクションを削除する
     - parameter transactionId: 削除するトランザクションID
     */
    func deleteTransaction(transactionId: String) async throws {
        try await fireStoreTransactionManager.deleteTransaction(transactionId: transactionId)
    }

    /**
     未精算の複数のトランザクションを精算済みにする
     */
    func updateResolvedTransactions() async throws {
        // 未精算のトランザクションに対して、resultTimeを登録
        let ids = unResolvedTransactions.map { $0.id }
        try await fireStoreTransactionManager.updateResolvedAt(transactionIds: ids, resolvedAt: Date())
    }

    /**
     未精算の1つののトランザクションを精算済みにする
     - parameter transactionId: 精算済みにするトランザクションID
     */
    func updateResolvedTransaction(transactionId: String) async throws {
        try await fireStoreTransactionManager.updateResolvedAt(transactionId: transactionId, resolvedAt: Date())
    }

    /**
     人物それぞれの金額を計算する
     - Description
     - 誰から誰にいくら払うかを計算
     - 自分の未清算の立替金額の合計を計算
     - パートナーの未清算の立替金額の合計を計算
     */
    private func calculateUnresolvedAmount() {
        // 取引合計金額を初期化
        var totalAmount: Int = 0
        var myTotalAmount: Int = 0
        var partnerTotalAmount: Int = 0

        // 未精算の取引から、ログインユーザーと相手ユーザーの支払金額を計算
        for unResolvedTransaction in self.unResolvedTransactions {
            // 自分が支払い者かどうかを判定
            let isCreditorMe = unResolvedTransaction.creditorId?.description == myUserId

            if isCreditorMe {
                myTotalAmount += unResolvedTransaction.amount
                totalAmount += unResolvedTransaction.amount
            } else {
                partnerTotalAmount += unResolvedTransaction.amount
                totalAmount -= unResolvedTransaction.amount
            }
        }

        // 支払い元・支払い先と未精算金額を更新
        DispatchQueue.main.async { [self] in
            // 立替金額がマイナスの場合、自分が相手に支払う必要がある
            // 立替金額がプラスの場合、相手が自分に支払う必要がある
            self.payFromName = totalAmount < 0 ? self.myUserName : self.partnerModifiedName
            self.payToName = totalAmount < 0 ? self.partnerModifiedName : self.myUserName
            self.unResolvedAmount = abs(totalAmount)
            self.myUnResolvedAmount = myTotalAmount
            self.partnerUnResolvedAmount = partnerTotalAmount
        }
    }

}
