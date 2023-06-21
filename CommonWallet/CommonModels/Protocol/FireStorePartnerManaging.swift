//
//  FireStorePartnerManaging.swift
//  CommonWallet
//

import Foundation

protocol FireStorePartnerManaging {
    func connectPartner(myUserId: String, partnerShareNumber: String) async throws -> Partner
    func deletePartner(myUserId: String, partnerUserId: String) async throws
    func realtimeFetchInfo(myUserId: String, completion: @escaping(Partner?, Error?) -> Void)
}
