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
    private let errorMessageManager = ErrorMessageManager()

    // MARK: - サインイン処理
    func signIn(email:String, password:String, complition: @escaping (Bool, String) -> Void ) async {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            complition(true, "ログイン成功")
        } catch {
            let errorMessage = errorMessageManager.getAuthErrorMessage(error)
            complition(false, errorMessage)
        }
    }

    // MARK: - サインアウト処理
    func signOut(complition: @escaping (Bool, String) -> Void ) async {
        do {
            try Auth.auth().signOut()
            complition(true, "サインアウト成功")
        } catch {
            complition(false, "サインアウトで不明なエラー")
        }
    }

     // MARK: - アカウント登録処理
    func createUser(email: String, password: String, name: String, complition: @escaping (Bool, String) -> Void ) async {

        var uid = String()

        // FirebaseAuthへのアカウント登録
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            uid = result.user.uid
        } catch {
            let errorMessage = errorMessageManager.getAuthErrorMessage(error)
            complition(false, errorMessage)
        }

        // FireStoreへのアカウント情報追加
        do {
            try await createUserToFireStore(userName: name, email: email, uid: uid)
            complition(true, "アカウント登録成功")
        } catch {
            let errorMessage = errorMessageManager.getFirestoreErrorMessage(error)
            complition(false, errorMessage)
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
    func deleteUser(complition: @escaping (Bool, String) -> Void ) async {

        guard let uid = Auth.auth().currentUser?.uid else {
            complition(false, "uidが見つからないため、アカウント削除失敗")
            return
        }

        // ①FireStoreのユーザデータ削除。この順番でないとFireStoreのユーザデータが削除できない
        do {
            try await deleteUserFromFireStore(uid: uid)
        } catch {
            let errorMessage = errorMessageManager.getFirestoreErrorMessage(error)
            complition(false, errorMessage)
        }

        // ②FirebaseAuthのユーザデータ削除。この順番でないとFireStoreのユーザデータが削除できない
        do {
            try await Auth.auth().currentUser?.delete()
        } catch {
            let errorMessage = errorMessageManager.getFirestoreErrorMessage(error)
            complition(false, errorMessage)
        }
    }

    // アカウント削除時に、FireStoreからもUserデータを削除
    private func deleteUserFromFireStore(uid: String) async throws {
        do {
            try await db.collection("Users").document(uid).delete()
            print("FireStoreへのUserデータ削除に成功")
        } catch {
            throw error
        }
    }

}
