//
//  UserManaging.swift
//  CommonWallet
//

import Foundation

protocol FireStoreUserManaging {

    // MARK: POST
    func createUser(userId: String, userName: String, iconPath: String, shareNumber: String, createdAt: Date) async throws

    // MARK: PUT
    func resetUser(userId: String, userName: String, iconPath: String, shareNumber: String) async throws
    func putUserName(userId: String, userName: String) async throws
    func putIconPath(userId: String, path: String) async throws

    // MARK: Fetch
    func realtimeFetchInfo(userId: String, completion: @escaping(User?, Error?) -> Void)

}
