//
//  UserManaging.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/22.
//

import Foundation

protocol FirestoreUserManager {
    func getUser() -> User?
    func getPartnerUid() -> String?
    func getPartnerName() -> String?
    func fetchLastResolvedAt(userId: String) async throws -> Date?
    func addPreviousResolvedAt(userId: String, previousResolvedAt: Date) async throws
    func addLastResolvedAt(userId: String, lastResolvedAt: Date) async throws
}
