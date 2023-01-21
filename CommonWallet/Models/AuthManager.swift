//
//  AuthManager.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/20.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

class AuthManager {

    private static let shared = AuthManager()
    private let db = Firestore.firestore()

    // MARK: - サインイン処理
    func signIn(email:String, password:String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw FirebaseErrorType.Auth(error as NSError)
        }
    }

    // MARK: - サインアウト処理
    func signOut() async throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw FirebaseErrorType.Auth(error as NSError)
        }
    }

     // MARK: - アカウント登録処理
    func createUser(email: String, password: String, name: String) async throws {

        var uid = String()

        // FirebaseAuthへのアカウント登録
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            uid = result.user.uid
        } catch {
            throw FirebaseErrorType.Auth(error as NSError)
        }

        // FireStoreへのアカウント情報追加
        do {
            try await createUserToFireStore(userName: name, email: email, uid: uid)
        } catch {
            throw FirebaseErrorType.FireStore(error as NSError)
        }
    }

    // アカウント登録時に、FireStoreにもUserデータを保存
    private func createUserToFireStore(userName: String, email: String, uid: String) async throws {
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

    // MARK: - アカウント削除処理
    func deleteUser() async throws {

        guard let uid = Auth.auth().currentUser?.uid else {
            throw FirebaseErrorType.other("uidが見つからない")
        }

        // ①FireStoreのユーザデータ削除。この順番でないとFireStoreのユーザデータが削除できない
        do {
            try await deleteUserFromFireStore(uid: uid)
        } catch {
            throw FirebaseErrorType.FireStore(error as NSError)
        }

        // ②FirebaseAuthのユーザデータ削除。この順番でないとFireStoreのユーザデータが削除できない
        do {
            try await Auth.auth().currentUser?.delete()
        } catch {
            throw FirebaseErrorType.Auth(error as NSError)
        }
    }

    // アカウント削除時に、FireStoreからもUserデータを削除
    private func deleteUserFromFireStore(uid: String) async throws {
        do {
            try await db.collection("Users").document(uid).delete()
        } catch {
            throw error
        }
    }

}
