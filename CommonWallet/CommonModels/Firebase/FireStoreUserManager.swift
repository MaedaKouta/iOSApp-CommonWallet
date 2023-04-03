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

    // MARK: Create
    func createUser(userId: String, userName: String, email: String, shareNumber: String) async throws {
        let user: Dictionary<String, Any> = ["id": userId,
                                             "name": userName,
                                             "email": email,
                                             "shareNumber": shareNumber,
                                             "createdAt": Timestamp(),
                                             ]
        do {
            try await db.collection("Users").document(userId).setData(user)
        } catch {
            throw error
        }
    }

    // MARK: Delete
    func deleteUser(userId: String) async throws {
        do {
            try await db.collection("Users").document(userId).delete()
        } catch {
            throw error
        }
    }

    // MARK: Fetch
    func fetchInfo(userId: String, completion: @escaping(User?, Error?) -> Void) {

         db.collection("Users").document(userId).getDocument { snapShot, error in
            if let error = error {
                print("Firestoreからユーザ情報の取得に失敗しました")
                completion(nil, error)
            }
            guard let data = snapShot?.data(),
                  let userId = data["id"] as? String,
                  let userName = data["name"] as? String,
                  let email = data["email"] as? String,
                  let shareNumber = data["shareNumber"] as? String,
                  let createdAt = data["createdAt"] as? Timestamp else { return }
             let user = User(id: userId, name: userName, email: email, shareNumber: shareNumber, createdAt: createdAt.dateValue())

            completion(user, nil)
        }
    }

    func fetchLastResolvedAt(userId: String, completion: @escaping(Date?, Error?) -> Void) {
         db.collection("Users").document(userId).getDocument { snapShot, error in
            if let error = error {
                print("FirestoreからLastResolvedAtの取得に失敗しました")
                completion(nil, error)
            }
            guard let data = snapShot?.data(),
                  let lastResolvedAt = data["lastResolvedAt"] as? Date else { return }

            completion(lastResolvedAt, nil)
        }
    }

    func fetchPreviousResolvedAt(userId: String, completion: @escaping(Date?, Error?) -> Void) {
         db.collection("Users").document(userId).getDocument { snapShot, error in
            if let error = error {
                print("FirestoreからPreviousResolvedAtの取得に失敗しました")
                completion(nil, error)
            }
            guard let data = snapShot?.data(),
                  let previousResolvedAt = data["previousResolvedAt"] as? Date else { return }

            completion(previousResolvedAt, nil)
        }
    }

    func fetchTransactions(userId: String, completion: @escaping([String]?, Error?) -> Void) {
         db.collection("Users").document(userId).getDocument { snapShot, error in
            if let error = error {
                print("FirestoreからTransactionsの取得に失敗しました")
                completion(nil, error)
            }
            guard let data = snapShot?.data(),
                  let transactions = data["transaction"] as? [String] else { return }

            completion(transactions, nil)
        }
    }

}
