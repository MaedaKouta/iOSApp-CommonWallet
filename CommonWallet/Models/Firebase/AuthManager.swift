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

        var uid = String()
        var fireStoreError: Error!

        do {
            // 通信して認証を行う
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            uid = result.user.uid
        } catch {
            throw FirebaseErrorType.Auth(error as NSError)
        }

        // サインインと同時に、UserDefaultsの情報も追加する処理
        fireStoreUserManager.fetchUser(uid: uid, completion: { user, error in
            if let user = user {
                self.userDefaultsManager.setUser(user: user)
            } else {
                fireStoreError = error
            }
        })
        if let error = fireStoreError {
            throw error
        }

        userDefaultsManager.isSignedIn = true

    }

    // MARK: - サインアウト処理
    func signOut() async throws {

        var fireStoreError: Error!

        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "サインインができていません。", code: 0)
        }

        // Authのサインアウト処理
        do {
            try Auth.auth().signOut()
            userDefaultsManager.clearUser()
        } catch {
            throw FirebaseErrorType.Auth(error as NSError)
        }

        // サインアウトと同時に、UserDefaultsの情報も削除する処理
        fireStoreUserManager.fetchUser(uid: uid, completion: { user, error in
            if let user = user {
                self.userDefaultsManager.setUser(user: user)
            } else {
                fireStoreError = error
            }
        })
        if let error = fireStoreError {
            throw error
        }

        userDefaultsManager.isSignedIn = false

    }

     // MARK: - アカウント登録処理
    func createUser(email: String, password: String, name: String, shareNumber: String) async throws {

        var uid = String()
        var fireStoreError: Error!

        // FirebaseAuthへのアカウント登録
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            uid = result.user.uid
        } catch {
            throw FirebaseErrorType.Auth(error as NSError)
        }

        // FireStoreへのアカウント情報追加
        do {
            try await fireStoreUserManager.createUser(userName: name, email: email, uid: uid, shareNumber: shareNumber)
        } catch {
            throw FirebaseErrorType.FireStore(error as NSError)
        }

        // アカウント登録と同時に、UserDefaultsの情報も追加する処理
        fireStoreUserManager.fetchUser(uid: uid, completion: { user, error in
            if let user = user {
                self.userDefaultsManager.setUser(user: user)
            } else {
                fireStoreError = error
            }
        })
        if let error = fireStoreError {
            throw error
        }

        userDefaultsManager.isSignedIn = true

    }

    // MARK: - アカウント削除処理
    func deleteUser() async throws {

        guard let uid = Auth.auth().currentUser?.uid else {
            throw FirebaseErrorType.other("uidが見つからない")
        }

        // ①FireStoreのユーザデータ削除。この順番でないとFireStoreのユーザデータが削除できない
        do {
            try await fireStoreUserManager.deleteUser(uid: uid)
            // アカウント削除と同時に、UserDefaultsの情報も削除する処理
            userDefaultsManager.clearUser()
        } catch {
            throw FirebaseErrorType.FireStore(error as NSError)
        }

        // ②FirebaseAuthのユーザデータ削除。この順番でないとFireStoreのユーザデータが削除できない
        do {
            try await Auth.auth().currentUser?.delete()
            userDefaultsManager.clearUser()
        } catch {
            throw FirebaseErrorType.Auth(error as NSError)
        }

        userDefaultsManager.isSignedIn = false
    }

}
