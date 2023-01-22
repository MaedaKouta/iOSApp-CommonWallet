//
//  FireStoreManager.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/22.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

class FireStoreUserManager {

    private let db = Firestore.firestore()
    private var userDefaultsManager = UserDefaultsManager()

    func createUser(userName: String, email: String, uid: String) async throws {
        let user: Dictionary<String, Any> = ["userName": userName,
                                             "uid": uid,
                                             "createdAt": Timestamp(),
                                             "email": email]
        do {
            try await db.collection("Users").document(uid).setData(user)
        } catch {
            throw error
        }
    }

    func deleteUser(uid: String) async throws {
        do {
            try await db.collection("Users").document(uid).delete()
        } catch {
            throw error
        }
    }

    // User情報の読み込み
    func fetchUser(uid: String) async throws -> User {
        do {
            let data = try await db.collection("Users").document(uid).getDocument().data()
            guard let userName = data?["userName"] as? String,
                  let mailAdress = data?["userName"] as? String,
                  let uid = data?["uid"] as? String
            else {
                throw NSError(domain: "fetcheUserDataでNillが取得されたエラー", code: 0)
            }
            let user = User(userName: userName, mailAdress: mailAdress, uid: uid)
            return user
        } catch {
            throw error
        }
    }
}
