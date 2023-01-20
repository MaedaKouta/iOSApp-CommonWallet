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
    private let auth = Auth.auth()
    private var errMessage: String = ""

    // MARK: - ログイン with email/password
    func login(email:String, password:String, complition: @escaping (Bool, String) -> Void ) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if error == nil {
                if result?.user != nil {
                    complition(true, "ログイン成功")
                } else {
                    complition(false, "不明なエラー")
                }
            } else {
                self.setErrorMessage(error)
                print(self.errMessage)
                complition(false, self.errMessage)
            }
        }
    }

     // MARK: - 新規登録
    func createUser(email: String, password: String, name: String, complition: @escaping (Bool, String) -> Void ) {

        let trimmingName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmingName.isEmpty {
            complition(false, "名前が空白です")
            return
        }

        auth.createUser(withEmail: email, password: password) { result, error in
            if error == nil {
                if result?.user != nil {
                    complition(true, "アカウント登録成功")
                } else {
                    complition(false, "不明なエラー")
                }
            } else {
                self.setErrorMessage(error)
                complition(false, self.errMessage)
            }
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
                default:
                    self.errMessage = "予期せぬエラーが発生しました。\nしばらく時間を置いてから再度お試しください。"
                }
            }
        }
    }
}
