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
    private var errMessage: String = ""

    // MARK: - ログイン処理 with email/password
    func login(email:String, password:String, complition: @escaping (Bool, String) -> Void ) async {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            complition(true, "ログイン成功")
        } catch {
            self.setErrorMessage(error)
            complition(false, self.errMessage)
        }
    }

     // MARK: - アカウント登録
    func createUser(email: String, password: String, name: String, complition: @escaping (Bool, String) -> Void ) async {

        let fireStoreUserManager = FireStoreUserManager()
        let trimmingName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmingName.isEmpty {
            complition(false, "名前が空白です")
            return
        }

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = result.user.uid
            try await fireStoreUserManager.createUser(userName: name, email: email, uid: uid)
            complition(true, "アカウント登録成功")
        } catch {
            self.setErrorMessage(error)
            complition(false, self.errMessage)
        }

    }

    private func setErrorMessage(_ error:Error?){
        if let error = error as NSError? {
            if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case .invalidEmail:
                    self.errMessage = "メールアドレスの形式が違います。"
                case .emailAlreadyInUse:
                    self.errMessage = "このメールアドレスはすでに使われています。"
                case .weakPassword:
                      self.errMessage = "パスワードが弱すぎます。"
                case .userNotFound, .wrongPassword:
                    self.errMessage = "メールアドレス、またはパスワードが間違っています"
                case .userDisabled:
                    self.errMessage = "このユーザーアカウントは無効化されています"
                case .networkError:
                    self.errMessage = "ネットワークエラーが発生しました。"
                default:
                    self.errMessage = "予期せぬエラーが発生しました。\nしばらく時間を置いてから再度お試しください。"
                }
            }
        }
    }

}
