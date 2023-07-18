//
//  CommonWalletApp.swift
//  CommonWallet
//

import SwiftUI
import Firebase

@main
struct CommonWalletApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .environmentObject(TransactionData())
                .environmentObject(SelectedEditTransaction())
        }
    }

}
