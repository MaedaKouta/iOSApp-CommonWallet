//
//  TabView.swift
//  CommonWallet
//

import SwiftUI

struct MainTabView: View {

    var body: some View {
        TabView {
            CommonWalletView(viewModel: CommonWalletViewModel(fireStoreTransactionManager: FireStoreTransactionManager(), fireStoreUserManager: FireStoreUserManager()))
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("ホーム")
                    }
                }.tag(1)
            AllLogView()
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
