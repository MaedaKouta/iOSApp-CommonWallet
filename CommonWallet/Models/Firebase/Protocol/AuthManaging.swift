//
//  AuthManaging.swift
//  CommonWallet
//

import Foundation
import FirebaseAuth

protocol AuthManaging {
    func signInAnonymously() async throws -> AuthDataResult
}
