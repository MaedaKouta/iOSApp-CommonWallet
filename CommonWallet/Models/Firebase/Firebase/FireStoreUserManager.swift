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

    // MARK: POST
    /**
     User情報を初期登録
     - parameter userId: ユーザーID
     - parameter userName: ユーザー名
     - parameter iconPath: アイコンのパス
     - parameter shareNumber: 共有番号
     */
    func createUser(userId: String, userName: String, iconPath: String, shareNumber: String) async throws {
        let user: Dictionary<String, Any> = ["id": userId,
                                             "name": userName,
                                             "iconPath": iconPath,
                                             "shareNumber": shareNumber,
                                             "createdAt": Timestamp(),
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

    // MARK: Delete
    /**
     自分のUser情報を削除
     - parameter userId: 自分のユーザーID
     */
    func deleteUser(userId: String) async throws {
        try await db.collection("Users").document(userId).delete()
    }

    // MARK: Fetch
    /**
     Uesr情報を返す
     - Description
     - FireStoreのアクセス回数が増えるため使用注意
     - parameter userId: 自分のユーザーID
     - Returns: Userを返す
     */
    func fetchInfo(userId: String) async throws -> User? {
        let user = try await db.collection("Users").document(userId)
            .getDocument(as: User.self)
        return user
    }

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
                  let userId = data["id"] as? String,
                  let userName = data["name"] as? String,
                  let iconPath = data["iconPath"] as? String,
                  let shareNumber = data["shareNumber"] as? String,
                  let createdAt = data["createdAt"] as? Timestamp else { return }

             let partnerUserId = data["partnerUserId"] as? String
             let partnerName = data["partnerName"] as? String
             let partnerShareNumber = data["partnerShareNumber"] as? String

            let user = User(id: userId, name: userName, shareNumber: shareNumber, iconPath: iconPath, createdAt: createdAt.dateValue(), partnerUserId: partnerUserId, partnerName: partnerName, partnerShareNumber: partnerShareNumber)

            completion(user, nil)
        }
    }

}
