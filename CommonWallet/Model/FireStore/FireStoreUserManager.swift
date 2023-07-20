//
//  FireStoreManager.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FireStoreUserManager: FireStoreUserManaging {

    private let db = Firestore.firestore()
    private let userDefaultsManager = UserDefaultsManager()

    // MARK: POST
    /**
     User情報を初期登録
     - parameter userId: ユーザーID
     - parameter userName: ユーザー名
     - parameter iconPath: アイコンのパス
     - parameter shareNumber: 共有番号
     */
    func createUser(userId: String, userName: String, iconPath: String, shareNumber: String, createdAt: Date, partnerName: String) async throws {
        let user: Dictionary<String, Any> = ["id": userId,
                                             "name": userName,
                                             "iconPath": iconPath,
                                             "shareNumber": shareNumber,
                                             "createdAt": createdAt,
                                             "partnerName": partnerName
                                             ]
        try await db.collection("Users").document(userId).setData(user)
    }

    /**
     User情報を初期登録
     - parameter userId: ユーザーID
     - parameter userName: ユーザー名
     - parameter iconPath: アイコンのパス
     - parameter shareNumber: 共有番号
     */
    func resetUser(userId: String, userName: String, iconPath: String, shareNumber: String, partnerName: String) async throws {
        let user: Dictionary<String, Any> = ["id": userId,
                                             "name": userName,
                                             "iconPath": iconPath,
                                             "shareNumber": shareNumber,
                                             "partnerName": partnerName
                                             ]
        try await db.collection("Users").document(userId).setData(user)
    }


    // MARK: PUT
    /**
     自分のUserNameを更新
     - parameter userId: 自分のユーザーID
     - parameter userName: 新しく登録するユーザー名
     */
    func putUserName(userId: String, userName: String) async throws {
        let user: Dictionary<String, Any> = ["name": userName]
        try await db.collection("Users").document(userId).setData(user, merge: true)
    }

    /**
     自分のIconPathを更新
     - parameter path: 新しいパス
     */
    func putIconPath(userId: String, path: String) async throws {
        let iconPath: Dictionary<String, Any> = ["iconPath": path]
        try await db.collection("Users").document(userId).setData(iconPath, merge: true)
    }

    func putPartnerName(userId: String, name: String) async throws {
        let partnerName: Dictionary<String, Any> = ["partnerName": name]
        try await db.collection("Users").document(userId).setData(partnerName, merge: true)
    }


    // MARK: Fetch
    /**
     リアルタイムに自分のUser情報を取得する
     - Description
     - FirebaseのaddSnapshotListenerを利用
     - 起動時に1度だけ呼び出しに利用
     - parameter userId: 自分のユーザーID
     - parameter completion: クロージャーでUserを返す
     */
    func realtimeFetchInfo(userId: String, completion: @escaping(User?, Error?) -> Void) {
        db.collection("Users").document(userId).addSnapshotListener { snapShot, error in
            if let error = error {
                print("FireStore UserInfo Fetch Error")
                completion(nil, error)
            }
            guard let data = snapShot?.data(),
                  let id = data["id"] as? String,
                  let name = data["name"] as? String,
                  let iconPath = data["iconPath"] as? String,
                  let shareNumber = data["shareNumber"] as? String,
                  let partnerName = data["partnerName"] as? String else { return }

             let partnerUserId = data["partnerUserId"] as? String
             let partnerShareNumber = data["partnerShareNumber"] as? String
             let iconData = userDefaultsManager.getMyIconData()

            // ここのpartnerNameが古いユーザーネームで更新される
            let user = User(
                id: id,
                name: name,
                shareNumber: shareNumber,
                iconPath: iconPath,
                iconData: iconData,
                partnerUserId: partnerUserId,
                partnerName: partnerName,
                partnerShareNumber: partnerShareNumber
            )
            completion(user, nil)
        }
    }

}
