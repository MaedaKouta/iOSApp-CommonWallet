//
//  OSLog.swift
//  CommonWallet
//
import os

extension OSLog {
    static let ui = Logger(subsystem: "org.tetoblog.OSLog", category: "ui")
    static let network = Logger(subsystem: "org.tetoblog.OSLog", category: "network")
    static let viewCycle = Logger(subsystem: "org.tetoblog.OSLog", category: "viewcycle")
    static let other = Logger(subsystem: "org.tetoblog.OSLog", category: "other")
}
