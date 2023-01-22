//
//  LaunchUtil.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/22.
//

import SwiftUI

enum LaunchStatus {
    case FirstLaunch
    case NewVersionLaunch
    case Launched
}

class LaunchStatusUtil {
    static let launchedVersionKey = "launchedVersion"
    @AppStorage(launchedVersionKey) static var launchedVersion = ""

    static var launchStatus: LaunchStatus {
        get{
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            let launchedVersion = self.launchedVersion

            self.launchedVersion = version

            if launchedVersion == "" {
                return .FirstLaunch
            }

            return version == launchedVersion ? .Launched : .NewVersionLaunch
        }
    }
}
