//
//  UserManaging.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/22.
//

import Foundation

protocol FireStoreUserManaging {

    // create
    func createUser(userId: String, userName: String, email: String, shareNumber: String) async throws

    // push
    func addLastResolvedAt(userId: String, lastResolvedAt: Date) async throws
    func addPreviousResolvedAt(userId: String, previousResolvedAt: Date) async throws

    // delete
    func deleteUser(userId: String) async throws

    // fetch
    func fetchInfo(userId: String, completion: @escaping(User?, Error?) -> Void)
    func fetchLastResolvedAt(userId: String) async throws -> Date?
    func fetchPreviousResolvedAt(userId: String) async throws -> Date?
    func fetchTransactions(userId: String, completion: @escaping([String]?, Error?) -> Void)
}
