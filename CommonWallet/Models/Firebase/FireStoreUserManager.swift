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
//    func fetchUser(uid: String) async throws -> User {
//        do {
//            let data = try await db.collection("Users").document(uid).getDocument().data()
//            guard let userName = data?["userName"] as? String,
//                  let mailAdress = data?["email"] as? String,
//                  let uid = data?["uid"] as? String
//            else {
//                throw NSError(domain: "fetcheUserDataでNillが取得されたエラー", code: 0)
//            }
//            let user = User(userName: userName, mailAdress: mailAdress, uid: uid)
//            return user
//        } catch {
//            throw error
//        }
//    }

    func fetchUser2(uid: String, completion: @escaping(User?, Error?) -> Void) {

         db.collection("Users").document(uid).getDocument { snapShot, error in
            if let error = error {
                print("Firestoreからユーザ情報の取得に失敗しました")
                completion(nil, error)
            }
            guard let data = snapShot?.data(),
                  let userName = data["userName"] as? String,
                  let mailAdress = data["email"] as? String,
                  let uid = data["uid"] as? String else { return }
            let user = User(userName: userName, mailAdress: mailAdress, uid: uid)

            completion(user,nil)
        }
    }
}
