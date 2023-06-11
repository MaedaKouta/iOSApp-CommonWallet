//
//  UserManaging.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/22.
//

import Foundation

protocol FireStoreUserManaging {

    // MARK: POST
    func createUser(userId: String, userName: String, email: String, iconPath: String, shareNumber: String) async throws

    // MARK: PUT
    func putUserName(userId: String, userName: String) async throws

    // MARK: Delete
    func deleteUser(userId: String) async throws

    // MARK: Fetch
    func fetchInfo(userId: String, completion: @escaping(User?, Error?) -> Void)

}
