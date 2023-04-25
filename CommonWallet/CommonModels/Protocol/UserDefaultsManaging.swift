//
//  UserDefaultsManaging.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/04/22.
//

import Foundation

protocol UserDefaultsManagerProtocol {
    func getUser() -> User?
    func getPartnerUid() -> String?
    func getPartnerName() -> String?
}
