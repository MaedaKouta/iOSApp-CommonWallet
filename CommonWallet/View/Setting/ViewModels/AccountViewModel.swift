//
//  AccountViewModel.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth
import SwiftUI
import FirebaseStorage

class AccountViewModel: ObservableObject {

    private var fireStoreTransactionManager: FireStoreTransactionManaging
    private var shareNumberManager =  ShareNumberManager()
    private var fireStoreUserManager: FireStoreUserManaging
    private var userDefaultsManager: UserDefaultsManager
    private var storageManager: StorageManaging
    private var authManager: AuthManaging

    @AppStorage(UserDefaultsKey().userId) private var myUserId = String()
    @AppStorage(UserDefaultsKey().myIconPath) private var myIconPath = String()

    init(fireStoreTransactionManager: FireStoreTransactionManaging,
         fireStoreUserManager: FireStoreUserManaging,
         userDefaultsManager: UserDefaultsManager,
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
        - fireStoreUserManager.putIconPathでFireStoreの更新
        - UserdefaultsのMyIconData・MyIconPathの更新
     - parameter image: アップロードするUIImage
     - parameter completion: アップロードしたパス / エラー
    */
    internal func uploadIcon(image: UIImage) async throws {

        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            throw StorageError.unknown("予期せぬエラーが発生しました。")
        }
        let uploadPath = try await self.uploadIconAsync(imageData: imageData)

        // StorageManager.deleteで古いアイコンの削除
        let oldIconImagePath = self.myIconPath
        self.storageManager.deleteImage(path: oldIconImagePath)

        // FireStoreのMyIconPathの更新
        try await self.fireStoreUserManager.putIconPath(userId: myUserId, path: uploadPath)

        // UserdefaultsのMyIconData・MyIconPathの更新
        self.userDefaultsManager.setMyIcon(path: uploadPath, imageData: imageData)

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
                ($0.debtorId == myUserId && $0.creditorId == "") ||
                ($0.debtorId == "" && $0.creditorId == myUserId)
            }
            .map { $0.id }
        // creditorIdに自分のIdが含まれていて、パートナーが存在する場合は、そこをnullにしてアップデート
        let myCreditorTransactionIds = transactions
            .filter{ ($0.creditorId == myUserId && $0.debtorId != "") }
            .map { $0.id }
        // debtorIdに自分のIdが含まれていて、パートナーが存在する場合は、そこをnullにしてアップデート
        let myDebtorTransactionIds = transactions
            .filter{ ($0.debtorId == myUserId && $0.creditorId != "") }
            .map { $0.id }

        // ここは非同期で並列処理。関数を抜けるまでには必ず処理される。
        async let _ = fireStoreTransactionManager.deleteTransactions(transactionIds: userNullTransactionIds)
        async let _ = fireStoreTransactionManager.updateCreditorNullOnTransactionIds(transactionIds: myCreditorTransactionIds)
        async let _ = fireStoreTransactionManager.updateDebtorNullOnTransactionIds(transactionIds: myDebtorTransactionIds)

        // IconImageの削除
        if let myIconPath = userDefaultsManager.getMyIconPath() {
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
        try await fireStoreUserManager.resetUser(userId: myUserId, userName: myUserName, iconPath: sampleMyIconPath, shareNumber: shareNumber, partnerName: partnerUserName)

        // Userdefaultsに保存
        userDefaultsManager.clearUser()

        let user = User(
            id: myUserId,
            name: myUserName,
            shareNumber: shareNumber,
            iconPath: sampleMyIconPath,
            iconData: sampleMyIconData,
            partnerUserId: nil,
            partnerName: partnerUserName,
            partnerShareNumber: nil
        )
        userDefaultsManager.setUser(user: user)
        userDefaultsManager.setPartnerIcon(path: samplePartnerIconPath, imageData: samplePartnerIconData)
    }


    // async
    private func uploadIconAsync(imageData: Data) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            storageManager.upload(imageData: imageData, completion: { path, error in

                if let error = error {
                    continuation.resume(throwing: error)
                }

                if let path = path {
                    continuation.resume(returning: path)
                } else {
                    continuation.resume(throwing: NSError())
                }
            })
        }
    }

}
