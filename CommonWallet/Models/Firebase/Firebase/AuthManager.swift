//
//  AuthManager.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

class AuthManager: AuthManaging {

    private static let shared = AuthManager()
    private let db = Firestore.firestore()
    private var fireStoreUserManager = FireStoreUserManager()
    private var userDefaultsManager = UserDefaultsManager()
    private var storageManager = StorageManager()

    // MARK: - サインイン処理
    func signIn(email:String, password:String) async throws {

        var userId = String()
        var fireStoreError: Error!

        do {
            // 通信して認証を行う
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            userId = result.user.uid
        } catch {
            throw FirebaseErrorType.Auth(error as NSError)
        }

        // サインインと同時に、UserDefaultsの情報も追加する処理
        fireStoreUserManager.realtimeFetchInfo(userId: userId, completion: { user, error in
            if let user = user {
                self.userDefaultsManager.setUser(user: user)
            } else {
                fireStoreError = error
            }
        })
        if let error = fireStoreError {
            throw error
        }

        userDefaultsManager.setIsSignedIn(isSignedIn: true)

    }

    // MARK: - サインアウト処理
    func signOut() async throws {

        var fireStoreError: Error!

        guard let userId = Auth.auth().currentUser?.uid else {
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
        fireStoreUserManager.realtimeFetchInfo(userId: userId, completion: { user, error in
            if let user = user {
                self.userDefaultsManager.setUser(user: user)
            } else {
                fireStoreError = error
            }
        })
        if let error = fireStoreError {
            throw error
        }

        userDefaultsManager.setIsSignedIn(isSignedIn: false)

    }

     // MARK: - アカウント登録処理
    func createUser(email: String, password: String, name: String, shareNumber: String) async throws {

        var userId = String()
        var fireStoreError: Error!
        // 20枚サンプル画像がある下のパスから、ランダムに取得
        let sampleMyIconPath = "icon-sample-images/sample\(Int.random(in: 1...20)).jpeg"
        let samplePartnerIconPath = "icon-sample-images/initial-partner-icon.jpeg"

        // FirebaseAuthへのアカウント登録
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            userId = result.user.uid
        } catch {
            throw FirebaseErrorType.Auth(error as NSError)
        }

        // FireStoreへのアカウント情報追加
        do {
            try await fireStoreUserManager.createUser(userId: userId, userName: name, email: email, iconPath: sampleMyIconPath, shareNumber: shareNumber)
        } catch {
            throw FirebaseErrorType.FireStore(error as NSError)
        }

        // sampleIconを取得して、ユーザーデフォルトに入れる
        // 自分のアイコン
        storageManager.download(path: sampleMyIconPath, completion: { data, error in
            if let data = data {
                self.userDefaultsManager.setMyIcon(path: sampleMyIconPath, imageData: data)
            } else {
                print("AuthManager: アカウント作成時、サンプルアイコンエラー")

            }
        })
        // パートナーのアイコン
        storageManager.download(path: samplePartnerIconPath, completion: { data, error in
            if let data = data {
                self.userDefaultsManager.setPartnerIcon(path: samplePartnerIconPath, imageData: data)
            } else {
                print("AuthManager: アカウント作成時、サンプルアイコンエラー")
            }
        })

        // アカウント登録と同時に、UserDefaultsの情報も追加する処理
        fireStoreUserManager.realtimeFetchInfo(userId: userId, completion: { user, error in
            if let user = user {
                self.userDefaultsManager.setUser(user: user)
            } else {
                fireStoreError = error
            }
        })
        if let error = fireStoreError {
            throw error
        }

        userDefaultsManager.setIsSignedIn(isSignedIn: true)

    }

    // MARK: - アカウント削除処理
    func deleteUser() async throws {

        guard let userId = Auth.auth().currentUser?.uid else {
            throw FirebaseErrorType.other("uidが見つからない")
        }

        // ①FireStoreのユーザデータ削除。この順番でないとFireStoreのユーザデータが削除できない
        do {
            try await fireStoreUserManager.deleteUser(userId: userId)
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

        userDefaultsManager.setIsSignedIn(isSignedIn: false)
    }

}
