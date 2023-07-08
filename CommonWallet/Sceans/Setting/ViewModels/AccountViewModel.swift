//
//  AccountViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth
import SwiftUI

class AccountViewModel: ObservableObject {

    private var fireStoreTransactionManager: FireStoreTransactionManaging
    private var shareNumberManager =  ShareNumberManager()
    private var fireStoreUserManager: FireStoreUserManaging
    private var userDefaultsManager: UserDefaultsManaging
    private var storageManager: StorageManaging
    private var authManager: AuthManaging

    init(fireStoreTransactionManager: FireStoreTransactionManaging,
         fireStoreUserManager: FireStoreUserManaging,
         userDefaultsManager: UserDefaultsManaging,
         storageManager: StorageManaging,
         authManager: AuthManaging) {
        self.fireStoreTransactionManager = fireStoreTransactionManager
        self.fireStoreUserManager = fireStoreUserManager
        self.userDefaultsManager = userDefaultsManager
        self.storageManager = storageManager
        self.authManager = authManager
    }

    /**
     アイコンをFireStorageへアップロード.
     - Description:
        - StorageManager.uploadでアイコンのアップロード
        - StorageManager.deleteで古いアイコンの削除
        - UserdefaultsのMyIconData・MyIconPathの更新
     - parameter image: アップロードするUIImage
     - parameter completion: 成功失敗のBool値 / エラー
    */
    internal func uploadIconImage(image: UIImage, completion: @escaping(Bool, Error?) -> Void) {

        storageManager.upload(image: image, completion: { [weak self] path, imageData, error in
            if error != nil {
                completion(false, error)
                return
            }

            guard let path = path,
                  let imageData = imageData else {
                completion(false, NSError())
                return
            }

            // StorageManager.deleteで古いアイコンの削除
            if let oldIconImagePath = self?.userDefaultsManager.getMyIconImagePath() {
                self?.storageManager.deleteImage(path: oldIconImagePath)
            }
            // UserdefaultsのMyIconData・MyIconPathの更新
            self?.userDefaultsManager.setMyIcon(path: path, imageData: imageData)
            completion(true, nil)
        })

    }

    /**
     アカウントリセットを行う
     - Description
     - トランザクションの削除
     - fireStoreのUserを削除
     - authから削除
     - UserDefaultsのクリーン
     - parameter transactions: 今持っている全てのトランザクション
     */
    internal func clearAccount(transactions: [Transaction]) async throws {

        guard let myUserId = Auth.auth().currentUser?.uid else { return }

        // トランザクションの削除
        // パートナーが空の場合、そのトランザションは削除
        let userNullTransactionIds = transactions
            .filter{
                ($0.debtorId == myUserId && $0.creditorId == nil) ||
                ($0.debtorId == nil && $0.creditorId == myUserId)
            }
            .map { $0.id }
        // creditorIdに自分のIdが含まれていて、パートナーが存在する場合は、そこをnullにしてアップデート
        let myCreditorTransactionIds = transactions
            .filter{ ($0.creditorId == myUserId && $0.debtorId != nil) }
            .map { $0.id }
        // debtorIdに自分のIdが含まれていて、パートナーが存在する場合は、そこをnullにしてアップデート
        let myDebtorTransactionIds = transactions
            .filter{ ($0.debtorId == myUserId && $0.creditorId != nil) }
            .map { $0.id }

        // ここは非同期で並列処理。関数を抜けるまでには必ず処理される。
        async let _ = fireStoreTransactionManager.deleteTransactions(transactionIds: userNullTransactionIds)
        async let _ = fireStoreTransactionManager.updateCreditorNullOnTransactionIds(transactionIds: myCreditorTransactionIds)
        async let _ = fireStoreTransactionManager.updateDebtorNullOnTransactionIds(transactionIds: myDebtorTransactionIds)

        // IconImageの削除
        if let myIconPath = userDefaultsManager.getMyIconImagePath() {
            storageManager.deleteImage(path: myIconPath)
        }

        // 初期情報定義
        let myUserName = "ユーザー"
        let partnerUserName = "パートナー"
        let sampleMyIconPath = "icon-sample-images/sample\(Int.random(in: 1...20)).jpeg"
        let samplePartnerIconPath = "icon-sample-images/initial-partner-icon.jpeg"
        let sampleMyIconData = try await storageManager.download(path: sampleMyIconPath)
        let samplePartnerIconData = try await storageManager.download(path: samplePartnerIconPath)
        let shareNumber = try await shareNumberManager.createShareNumber()

        // トランザクションにアカウント登録
        try await fireStoreUserManager.createUser(userId: myUserId, userName: myUserName, iconPath: sampleMyIconPath, shareNumber: shareNumber)

        // Userdefaultsに保存
        userDefaultsManager.clearUser()
        userDefaultsManager.clearPartner()
        let user = User(id: myUserId, name: myUserName, shareNumber: shareNumber, iconPath: sampleMyIconPath, iconData: sampleMyIconData, createdAt: Date())
        let partner = Partner(userName: partnerUserName, iconPath: samplePartnerIconPath, iconData: samplePartnerIconData)
        userDefaultsManager.createUser(user: user)
        userDefaultsManager.createPartner(partner: partner)
    }

}
