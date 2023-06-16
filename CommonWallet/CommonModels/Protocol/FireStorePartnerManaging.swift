//
//  FireStorePartnerManaging.swift
//  CommonWallet
//

import Foundation

protocol FireStorePartnerManaging {
    func connectPartner(partnerShareNumber: String) async throws -> Partner
    func deletePartner(myUserId: String, partnerUserId: String) async throws
    func fetchPartnerInfo(completion: @escaping(User?, Error?) -> Void)
}
