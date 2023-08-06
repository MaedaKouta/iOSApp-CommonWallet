//
//  LaunchUtil.swift
//  CommonWallet
//

import SwiftUI

enum LaunchStatusType {
    case firstLaunch
    case newVersionLaunch
    case launched
}

class LaunchStatus {
    @AppStorage(UserDefaultsKey().launchedVersion) static var launchedVersion = ""

    static var launchStatus: LaunchStatusType {
        get {
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            let launchedVersion = self.launchedVersion

            self.launchedVersion = version

            if launchedVersion == "" {
                return .firstLaunch
            }

            return version == launchedVersion ? .launched : .newVersionLaunch
        }
    }

}
