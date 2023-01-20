//
//  CreateUserToFireStore.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/20.
//

import Foundation
import Firebase
import FirebaseFirestore

class FireStoreUserManager {

    private let db = Firestore.firestore()

    func createUser(userName: String, email: String, uid: String) async throws {

        //guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let user: Dictionary<String, Any> = ["userName": userName,
                                             "uid": uid,
                                             "createdAt": Timestamp(),
                                             "email": email]
        do {
            try await db.collection("Users").document(uid).setData(user)
            print("Userデータの送信に成功しました")
        } catch {
            print("Userデータの送信に失敗しました")
        }
    }

}
