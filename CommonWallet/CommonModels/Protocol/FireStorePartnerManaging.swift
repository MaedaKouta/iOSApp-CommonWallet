//
//  FireStorePartnerManaging.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/22.
//

import Foundation

protocol FireStorePartnerManaging {
    func connectPartner(partnerShareNumber: String) async -> Bool
    func deletePartner() async -> Bool
    func fetchDeletePartner() async
}
