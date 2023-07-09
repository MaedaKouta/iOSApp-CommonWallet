//
//  CreateUserViewModel.swift
//  CommonWallet
//

//import Foundation
//
//class CreateUserViewModel: ObservableObject {
//    let authManager = AuthManager()
//    let errorMessageManegar = FirebaseErrorManager()
//    let shareNumberManager = ShareNumberManager()
//
//    func createUser(email: String, password: String, name: String, complition: @escaping (Bool, String) -> Void) async {
//
//        // ユーザーの共有番号を作る
//        var shareNumber = ""
//        do {
//            shareNumber = await shareNumberManager.createShareNumber()
//        }
//
//        do {
//            try await authManager.createUser(email: email, password: password, name: name, shareNumber: shareNumber)
//            complition(true, "アカウント登録成功")
//
//        } catch FirebaseErrorType.Auth(let error) {
//            let errorMessage = errorMessageManegar.getAuthErrorMessage(error)
//            complition(false, errorMessage)
//        } catch FirebaseErrorType.FireStore(let error) {
//            let errorMessage = errorMessageManegar.getFireStoreErrorMessage(error)
//            complition(false, errorMessage)
//        } catch {
//            complition(false, "不明なエラー")
//        }
//    }
//}
