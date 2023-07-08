//
//  TabView.swift
//  CommonWallet
//

import SwiftUI

struct MainTabView: View {

<<<<<<< HEAD:CommonWallet/Sceans/MainTab/View/MainTabView.swift
    @ObservedObject var mainTabViewModel = MainTabViewModel()
=======
    @ObservedObject var viewModel = MainTabViewModel()
>>>>>>> 91231b0 (fix: addSnapshotListenerの修正):CommonWallet/Sceans/MainTab/MainTabView.swift

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
        }.onAppear {
            Task {
                await viewModel.realtimeFetchPartnerInfo()
                await viewModel.realtimeFetchUserInfo()
            }
        }
    }

}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
