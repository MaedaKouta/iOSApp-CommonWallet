//
//  AccountViewModel.swift
//  CommonWallet
//

import Foundation
import SwiftUI

class AccountViewModel: ObservableObject {

    private var userDefaultsManager: UserDefaultsManaging
    private var storageManager: StorageManaging

    init(userDefaultsManager: UserDefaultsManaging, storageManager: StorageManaging) {
        self.userDefaultsManager = userDefaultsManager
        self.storageManager = storageManager
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

}
