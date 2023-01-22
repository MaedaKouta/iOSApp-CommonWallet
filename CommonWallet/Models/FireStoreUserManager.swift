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

    private let userNameKey = "userName"
    @AppStorage(userNameKey) var userName = ""

    func fetchUserData(uid: String, completion: @escaping(String?, Error?) -> Void) {
        db.collection("Users").document(uid).getDocument { snapShot, error in
            if let error = error {
                print("Firestoreからユーザ情報の取得に失敗しました")
                completion(nil,error)
            }
            guard let data = snapShot?.data() else { return }
            guard let userName = data["userName"] as? String else { return }
            completion(userName,nil)
        }
    }

    func fetchUserData(uid: String) async throws -> [String: Any]? {
        try await db.collection("Users").document(uid).getDocument().data()
    }

}
