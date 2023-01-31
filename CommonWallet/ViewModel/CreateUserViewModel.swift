//
//  CreateUserViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/21.
//

import Foundation

class CreateUserViewModel: ObservableObject {
    let authManager = AuthManager()
    let errorMessageManegar = FirebaseErrorManager()
    let shareNumberManager = ShareNumberManager()

    func createUser(email: String, password: String, name: String, complition: @escaping (Bool, String) -> Void) async {

        // ユーザーの共有番号を作る
        var shareNumber = ""
        do {
            shareNumber =  try await shareNumberManager.createShareNumber()
        } catch {
            print("失敗")
        }

        do {
            try await authManager.createUser(email: email, password: password, name: name, shareNumber: shareNumber)
            complition(true, "アカウント登録成功")

        } catch FirebaseErrorType.Auth(let error) {
            let errorMessage = errorMessageManegar.getAuthErrorMessage(error)
            complition(false, errorMessage)
        } catch FirebaseErrorType.FireStore(let error) {
            let errorMessage = errorMessageManegar.getFirestoreErrorMessage(error)
            complition(false, errorMessage)
        } catch {
            complition(false, "不明なエラー")
        }
    }
}
