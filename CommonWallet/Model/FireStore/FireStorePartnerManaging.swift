//
//  FireStorePartnerManaging.swift
//  CommonWallet
//

import Foundation

protocol FireStorePartnerManaging {
    func connectPartner(myUserId: String, partnerShareNumber: String) async throws -> User
    func deletePartner(myUserId: String, partnerUserId: String) async throws
    func realtimeFetchPartnerInfo(partnerUserId: String, completion: @escaping(User?, Error?) -> Void)
    func putPartnerName(userId: String, name: String) async throws
}
