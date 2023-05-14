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

    func addLastResolvedAt(userId: String, lastResolvedAt: Date) async throws {
        do {
            try await db.collection("Users").document(userId)
                .updateData([
                    "lastResolvedAt": lastResolvedAt
                ])
        } catch {
            throw error
        }
    }

    func addPreviousResolvedAt(userId: String, previousResolvedAt: Date) async throws {
        do {
            try await db.collection("Users").document(userId)
                .updateData([
                    "previousResolvedAt": previousResolvedAt
                ])
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

        db.collection("Users").document(userId).addSnapshotListener { snapShot, error in
            if let error = error {
                print("FireStore UserInfo Fetch Error")
                completion(nil, error)
            }
            guard let data = snapShot?.data(),
                  let userId = data["id"] as? String,
                  let userName = data["name"] as? String,
                  let email = data["email"] as? String,
                  let shareNumber = data["shareNumber"] as? String,
                  let createdAt = data["createdAt"] as? Timestamp else { return }

             let partnerUserId = data["partnerUserId"] as? String
             let partnerName = data["partnerName"] as? String
             let partnerShareNumber = data["partnerShareNumber"] as? String

             let user = User(id: userId, name: userName, email: email, shareNumber: shareNumber, createdAt: createdAt.dateValue(), partnerUserId: partnerUserId, partnerName: partnerName, partnerShareNumber: partnerShareNumber)

            completion(user, nil)
        }
    }

    func fetchLastResolvedAt(userId: String) async throws -> Date? {
        do {
            
            let snapShot = try await db.collection("Users").document(userId).getDocument()
            guard let data = snapShot.data(),
                  let lastResolvedAt = data["lastResolvedAt"] as? Timestamp else { return nil }

            return lastResolvedAt.dateValue()
        } catch {
            print("FirestoreからLastResolvedAtの取得に失敗しました: \(error)")
            throw error
        }
    }

    func fetchPreviousResolvedAt(userId: String) async throws -> Date? {
        do {
            let snapShot = try await db.collection("Users").document(userId).getDocument()
            guard let data = snapShot.data(),
                  let previousResolvedAt = data["previousResolvedAt"] as? Timestamp else { return nil }

            return previousResolvedAt.dateValue()
        } catch {
            print("FirestoreからLastResolvedAtの取得に失敗しました: \(error)")
            throw error
        }
    }

    func fetchLastResolvedAt(userId: String, completion: @escaping(Date?, Error?) -> Void) {
        db.collection("Users").document(userId).getDocument { snapShot, error in

            if let error = error {
                print("FirestoreからTransactionsの取得に失敗しました")
                completion(nil, error)
            }
            guard let data = snapShot?.data(),
                  let lastResolvedAt = data["lastResolvedAt"] as? Timestamp else {
                    completion(nil, nil)
                    return
                }

            completion(lastResolvedAt.dateValue(), nil)
        }
    }

    func fetchPreviousResolvedAt(userId: String, completion: @escaping(Date?, Error?) -> Void) {
        db.collection("Users").document(userId).getDocument { snapShot, error in

            if let error = error {
                print("FirestoreからTransactionsの取得に失敗しました")
                completion(nil, error)
            }
            guard let data = snapShot?.data(),
                  let previousResolvedAt = data["previousResolvedAt"] as? Timestamp else {
                    completion(nil, nil)
                    return
                }
            completion(previousResolvedAt.dateValue(), nil)
        }
    }

}
