//
//  UserManaging.swift
//  CommonWallet
//

import Foundation

protocol FireStoreUserManaging {

    // MARK: POST
    func createUser(userId: String, userName: String, iconPath: String, shareNumber: String) async throws

    // MARK: PUT
    func putUserName(userId: String, userName: String) async throws

    // MARK: Fetch
    func fetchInfo(userId: String) async throws -> User?
    func realtimeFetchInfo(userId: String, completion: @escaping(User?, Error?) -> Void)

}
