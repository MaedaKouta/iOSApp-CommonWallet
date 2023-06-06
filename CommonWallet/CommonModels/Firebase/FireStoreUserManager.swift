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

class FireStoreUserManager: FireStoreUserManaging {

    private let db = Firestore.firestore()
    private var userDefaultsManager = UserDefaultsManager()

    // MARK: POST
    func createUser(userId: String, userName: String, email: String, iconPath: String, shareNumber: String) async throws {

        let user: Dictionary<String, Any> = ["id": userId,
                                             "name": userName,
                                             "email": email,
                                             "iconPath": iconPath,
                                             "shareNumber": shareNumber,
                                             "createdAt": Timestamp(),
                                             ]
        try await db.collection("Users").document(userId).setData(user)
    }

    // MARK: PUT
    func putUserName(userId: String, userName: String) async throws {
        let user: Dictionary<String, Any> = ["name": userName]
        try await db.collection("Users").document(userId).setData(user, merge: true)
    }

    // MARK: Delete
    func deleteUser(userId: String) async throws {
        try await db.collection("Users").document(userId).delete()
    }

    // MARK: Fetch
    func fetchInfo(userId: String, completion: @escaping(User?, Error?) -> Void) {

        db.collection("Users").document(userId).addSnapshotListener { snapShot, error in
            if let error = error {
                print("FireStore UserInfo Fetch Error")
                completion(nil, error)
            }
            guard let data = snapShot?.data(),
                  let userId = data["id"] as? String,
                  let userName = data["name"] as? String,
                  let email = data["email"] as? String,
                  let iconPath = data["iconPath"] as? String,
                  let shareNumber = data["shareNumber"] as? String,
                  let createdAt = data["createdAt"] as? Timestamp else { return }

             let partnerUserId = data["partnerUserId"] as? String
             let partnerName = data["partnerName"] as? String
             let partnerShareNumber = data["partnerShareNumber"] as? String

            let user = User(id: userId, name: userName, email: email, shareNumber: shareNumber, iconPath: iconPath, createdAt: createdAt.dateValue(), partnerUserId: partnerUserId, partnerName: partnerName, partnerShareNumber: partnerShareNumber)

            completion(user, nil)
        }
    }

}
