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

    internal func uploadIconImage(image: UIImage, completion: @escaping(Bool, Error?) -> Void) {

        // 画像のアップロード
        // 古い画像の削除
        // Userdefaultsのパス情報・データの更新
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
            if let oldIconImagePath = self?.userDefaultsManager.getMyIconImagePath() {
                self?.storageManager.deleteImage(path: oldIconImagePath)
            }
            self?.userDefaultsManager.setMyIcon(path: path, imageData: imageData)
            completion(true, nil)
        })

    }

}
