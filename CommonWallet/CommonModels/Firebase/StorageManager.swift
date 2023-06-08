//
//  FirebaseStorageManager.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/06/03.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseStorage

class StorageManager: StorageManaging {

    private var userDefaultsManager: UserDefaultsManager
    private let storage: Storage
    private let reference: StorageReference

    init() {
        userDefaultsManager = UserDefaultsManager()
        storage = Storage.storage()
        reference = storage.reference()
    }

    /// アイコン画像のアップロード
    func upload(image: UIImage, completion: @escaping(String?, Data?, StorageError?) -> Void) {

        guard let data = image.jpegData(compressionQuality: 0.1) else {
            completion(nil, nil, StorageError.unknown("予期せぬエラーが発生しました。"))
            return
        }

        let path = "icon-images/" + UUID().uuidString
        let imageRef = reference.child(path)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        let uploadTask = imageRef.putData(data, metadata: metadata)

        uploadTask.observe(.success) { snapshot in
            // FireStorageの古いデータを削除する
            if let oldIconImagePath = self.userDefaultsManager.getMyIconImagePath() {
                self.deleteImage(path: oldIconImagePath)
            }
            completion(path, data, nil)
        }

        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as? NSError {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    completion(nil, nil, StorageError.objectNotFound("画像が見つかりません。"))
                    break
                default:
                    completion(nil, nil,  StorageError.unknown("予期せぬエラーが発生しました。"))
                    break
                }
            } else {
                completion(nil, nil, StorageError.unknown("予期せぬエラーが発生しました。"))
            }
        }
    }

    /// 画像をインポートして、その画像をDate型を返す
    /// UIImage型ではなくData型で保存するのは、UserDefaultsがData型しか保存できないため
    func download(path: String, completion: @escaping(Data?, Error?) -> Void) {

        let islandRef = reference.child(path)

        // ダウンロードは最大10MB(10 * 1024 * 1024 bytes)まで許可
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(data, nil)
                print("image download success")
            }
        }
    }

    /*
     FireStorageの画像を削除する
     自分のアイコンを更新するときに、古いアイコンを削除する際に利用
     失敗しても大したことないので、エラーハンドリングはしない
     */
    internal func deleteImage(path: String) {
        // サンプル画像の場合は削除させない
        if path.contains("icon-sample-images/") {
            return
        }

        let imageRef = reference.child(path)
        imageRef.delete { error in
            if error != nil {
                print("Uh-oh, an error occurred!")
            } else {
                print("delete success!!")
            }
        }
    }

}
