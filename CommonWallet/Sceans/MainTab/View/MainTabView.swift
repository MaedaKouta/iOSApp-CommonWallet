//
//  TabView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import SwiftUI

struct MainTabView: View {

    @ObservedObject var mainTabViewModel = MainTabViewModel()

    var body: some View {
        TabView {
            CommonWalletView(commonWalletViewModel: CommonWalletViewModel(fireStoreTransactionManager: FireStoreTransactionManager(), fireStoreUserManager: FireStoreUserManager(), userDefaultsManager: UserDefaultsManager()))
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("ホーム")
                    }
                }.tag(1)
            AllLogView(allLogViewModel: AllLogViewModel())
                .tabItem {
                    VStack {
                        Image(systemName: "tray.full")
                        Text("履歴")
                    }
                }.tag(2)
        }
    }


}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
