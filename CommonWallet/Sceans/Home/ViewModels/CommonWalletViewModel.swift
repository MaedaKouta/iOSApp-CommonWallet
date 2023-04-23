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

    private var fireStoreTransactionManager: FireStoreTransactionManager
    private var fireStoreUserManager: FireStoreUserManager
    private var userDefaultsManager: UserDefaultsManager

    init(fireStoreTransactionManager: FireStoreTransactionManager, fireStoreUserManager: FireStoreUserManager, userDefaultsManager: UserDefaultsManager) {
        self.fireStoreTransactionManager = fireStoreTransactionManager
        self.fireStoreUserManager = fireStoreUserManager
        self.userDefaultsManager = userDefaultsManager
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

    func fetchTransactions() async throws -> Result<Void, Error> {

        // UserdefaultsからmyUserIdの取得
        guard let userId = userDefaultsManager.getUser()?.id else {
            throw UserDefaultsError.emptyUserIds
        }

        do {
            // 精算済みのデータ取得・更新
            // 未精算データの取得・更新
//            let result = try await fireStoreTransactionManager.fetchResolvedTransactions(userId: userId)
//            let unResolvedResult = try await fireStoreTransactionManager.fetchUnResolvedTransactions(userId: userId)
            //let aaa = try await fireStoreTransactionManager.fetchUnResolvedTransactions2(userId: userId)
           // print("#######", aaa)
            //let result = try await fireStoreTransactionManager.fetchResolvedTransactions(userId: userId)
            //let unResolvedResult = try await fireStoreTransactionManager.fetchUnResolvedTransactions(userId: userId)
//            fireStoreTransactionManager.fetchTransactionIds2(userId: userId, completion: {strings, error in
//
//                guard let ids = strings else {
//                    return
//                }
//                self.fireStoreTransactionManager.fetchUnResultMyTransactions2(ids: ids, completion: { aaa, error in
//                    print(aaa)
//                    guard let aaaa = aaa else { return }
//                    self.unResolvedTransactions = aaaa
//                })
//            })
            fireStoreTransactionManager.fetchUnResultTransactions2(completion: { aaa, error in
                self.unResolvedTransactions = []
                print(aaa)
                guard let aaaa = aaa else { return }
                self.unResolvedTransactions = aaaa
            })
//
//            fireStoreTransactionManager.fetchTransactionIds2(userId: userId, completion: {strings, error in
//
//                guard let ids = strings else {
//                    return
//                }
//                self.payFromName = "\(ids.count)"
//            })
//            DispatchQueue.main.async {
//                //self.unResolvedTransactions = unResolvedResult ?? []
//                //self.resolvedTransactions = result ?? [Transaction]()
//            }

            // 〇〇から〇〇へ〇〇円を計算・アウトプットする関数
            self.calculateUnresolvedAmount()

            // 成功した場合
            return .success(())
        } catch {
            // TODO: エラーハンドリング
            // 失敗した場合
            print("fetchTransactions failed with error: \(error)")
            return .failure(error)
        }

    }

    /// 精算を完了させる関数
    func pushResolvedTransaction() async throws -> Result<Void, Error> {
        do {
            // 精算実行時刻を取得
            let resultTime = Date()
            // 自分と相手のユーザーIDを取得
            guard let myUserId = userDefaultsManager.getUser()?.id,
                  let partnerUserId = userDefaultsManager.getPartnerUid() else {
                throw UserDefaultsError.emptyUserIds
            }

            // 未精算のトランザクションに対して、resultTimeを登録
            for unResolvedTransaction in unResolvedTransactions {
                try await fireStoreTransactionManager.addResolvedAt(transactionId: unResolvedTransaction.id, resolvedAt: resultTime)
            }

            // 自分と相手のユーザーのpreviousResolvedAtを更新
            let lastResolvedAt = try await fireStoreUserManager.fetchLastResolvedAt(userId: myUserId)
            if let lastResolvedAt = lastResolvedAt {
                try await fireStoreUserManager.addPreviousResolvedAt(userId: myUserId, previousResolvedAt: lastResolvedAt)
                try await fireStoreUserManager.addPreviousResolvedAt(userId: partnerUserId, previousResolvedAt: lastResolvedAt)
            } else {
                // TODO: エラーハンドリング？
                print("resolveTransaction関数内でlastResolvedAtが空のまま処理")
            }

            // 自分と相手のユーザーのlastResolvedAtにresultTimeを登録
            try await fireStoreUserManager.addLastResolvedAt(userId: myUserId, lastResolvedAt: resultTime)
            try await fireStoreUserManager.addLastResolvedAt(userId: partnerUserId, lastResolvedAt: resultTime)

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
            let isCreditorMe = unResolvedTransaction.creditorId.description == myUserId
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
