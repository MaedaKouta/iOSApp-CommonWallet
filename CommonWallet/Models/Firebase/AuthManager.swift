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
    private var fireStoreUserManager = FireStoreUserManager()
    private var userDefaultsManager = UserDefaultsManager()

    // MARK: - サインイン処理
    func signIn(email:String, password:String) async throws {
        do {
            // 通信して認証を行う
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw FirebaseErrorType.Auth(error as NSError)
        }
    }

    // MARK: - サインアウト処理
    func signOut() async throws {
        // Authのサインアウト処理
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
            try await fireStoreUserManager.createUser(userName: name, email: email, uid: uid)

        } catch {
            throw FirebaseErrorType.FireStore(error as NSError)
        }
    }

    // MARK: - アカウント削除処理
    func deleteUser() async throws {

        guard let uid = Auth.auth().currentUser?.uid else {
            throw FirebaseErrorType.other("uidが見つからない")
        }

        // ①FireStoreのユーザデータ削除。この順番でないとFireStoreのユーザデータが削除できない
        do {
            try await fireStoreUserManager.deleteUser(uid: uid)
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

}
