//
//  ShareNumberManaging.swift
//  CommonWallet
//

import Foundation

protocol ShareNumberManaging {
    func createShareNumber() async throws -> String
}
