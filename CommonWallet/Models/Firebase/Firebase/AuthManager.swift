//
//  AuthManager.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth

class AuthManager: AuthManaging {

    func signInAnonymously() async throws -> AuthDataResult {
        return try await Auth.auth().signInAnonymously()
    }

}
