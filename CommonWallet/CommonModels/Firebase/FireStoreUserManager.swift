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

    func createUser(createdAt: Timestamp, userName: String, email: String, uid: String, shareNumber: String) async throws {
        let user: Dictionary<String, Any> = ["userName": userName,
                                             "uid": uid,
                                             "createdAt": createdAt,
                                             "email": email,
                                             "shareNumber": shareNumber]
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

    func fetchUser(uid: String, completion: @escaping(User?, Error?) -> Void) {

         db.collection("Users").document(uid).getDocument { snapShot, error in
            if let error = error {
                print("Firestoreからユーザ情報の取得に失敗しました")
                completion(nil, error)
            }
            guard let data = snapShot?.data(),
                  let userName = data["userName"] as? String,
                  let mailAdress = data["email"] as? String,
                  let uid = data["uid"] as? String,
                  let shareNumber = data["shareNumber"] as? String,
                  let createdAt = data["createdAt"] as? Timestamp else { return }
             let user = User(id: uid, userName: userName, email: mailAdress, shareNumber: shareNumber, createdAt: createdAt.dateValue())

            completion(user,nil)
        }
    }
}
