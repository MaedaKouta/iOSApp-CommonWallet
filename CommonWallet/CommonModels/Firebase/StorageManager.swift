//
//  FirebaseStorageManager.swift
//  CommonWallet
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseStorage

/// FireStorageの操作を行うクラス
struct StorageManager: StorageManaging {

    private var userDefaultsManager: UserDefaultsManaging
    private let storage: Storage
    private let reference: StorageReference

    init() {
        userDefaultsManager = UserDefaultsManager()
        storage = Storage.storage()
        reference = storage.reference()
    }

    /**
     アイコンをFireStorageへアップロード
     - Description
        - 渡された画像データから品質0.1倍のjpegデータに変換してアップロード
            - アイコン画像に高画質は求められていないため
        - FireStorageに保存するパスは "icon-images/ + UUID().uuidString" とする
            - "icon-images/ + UserId" ではアイコン変更をパートナー側で判別するのが難しいため
     - parameter image: アップロードするUIImage
     - Returns : アップロードしたパス情報 / アップロードしたアイコンデータ / エラー
    */
    internal func upload(image: UIImage, completion: @escaping(String?, Data?, StorageError?) -> Void) {

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
            print("StorageManager: image upload success!")
            completion(path, data, nil)
        }

        uploadTask.observe(.failure) { snapshot in
            print("StorageManager: image upload failure!")
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

    /**
     アイコンをFireStorageからダウンロード
     - Description
        - ダウンロードは最大10MB(10 * 1024 * 1024 bytes)まで許可
            - 変な処理が発生し、通信容量が増えることでFireStorageの無料枠が超えることを回避している
     - parameter path: ダウンロードするアイコンのパス
     - Returns : アイコンデータ / エラー
    */
    func download(path: String, completion: @escaping(Data?, Error?) -> Void) {
        let islandRef = reference.child(path)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(data, nil)
                print("StorageManager: image download success!")
            }
        }
    }

    /**
     アイコンをFireStorageから削除.
     失敗しても大したことないため, エラーハンドリングはしていない.
     - Description
        - サンプルアイコンは削除させないようロジック内に記述済み
     - parameter path: 削除するアイコンのパス
    */
    internal func deleteImage(path: String) {

        // サンプルアイコンは, FireStorage内別ファイル(icon-sample-images/)に保存している
        if path.contains("icon-sample-images/") {
            return
        }

        let imageRef = reference.child(path)
        imageRef.delete { error in
            if error != nil {
                print("StorageManager: delete error occurred!")
            } else {
                print("StorageManager: delete Success!")
            }
        }
    }

}
