//
//  LoginViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/21.
//

import Foundation

class SignInViewModel: ObservableObject {
    let authManager = AuthManager()
    let errorMessageManegar = ErrorMessageManager()

    func signIn(email: String, password: String, complition: @escaping (Bool, String) -> Void) async {
        do {
            try await authManager.signIn(email: email, password: password)
            complition(true, "サインインの成功")
        } catch FirebaseErrorType.Auth(let error){
            let errorMessage = errorMessageManegar.getAuthErrorMessage(error)
            complition(false, errorMessage)
        } catch {
            complition(false, "不明なエラー")
        }
    }

}
