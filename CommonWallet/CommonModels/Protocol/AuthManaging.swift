//
//  AuthManaging.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/22.
//

import Foundation

protocol AuthManaging {
    func signIn(email:String, password:String) async throws
    func signOut() async throws
    func createUser(email: String, password: String, name: String, shareNumber: String) async throws
    func deleteUser() async throws
}
