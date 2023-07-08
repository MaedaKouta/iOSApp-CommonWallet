//
//  LoginViewModel.swift
//  CommonWallet
//

//import Foundation
//
//class SignInViewModel: ObservableObject {
//    let authManager = AuthManager()
//    let errorMessageManegar = FirebaseErrorManager()
//
//    func signIn(email: String, password: String, complition: @escaping (Bool, String) -> Void) async {
//        do {
//            try await authManager.signIn(email: email, password: password)
//            complition(true, "サインインの成功")
//        } catch FirebaseErrorType.Auth(let error){
//            let errorMessage = errorMessageManegar.getAuthErrorMessage(error)
//            complition(false, errorMessage)
//        } catch {
//            complition(false, "不明なエラー")
//        }
//    }
//
//}
