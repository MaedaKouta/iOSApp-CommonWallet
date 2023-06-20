//
//  AuthManaging.swift
//  CommonWallet
//

import Foundation

protocol AuthManaging {
    func signIn(email:String, password:String) async throws
    func signOut() async throws
    func createUser(email: String, password: String, name: String, shareNumber: String) async throws
    func deleteUser() async throws
}
