//
//  LaunchUtil.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/22.
//

import SwiftUI

enum LaunchStatusType {
    case FirstLaunch
    case NewVersionLaunch
    case Launched
}

class LaunchStatus {
    @AppStorage(UserDefaultsKey().launchedVersion) static var launchedVersion = ""

    static var launchStatus: LaunchStatusType {
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
