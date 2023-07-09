//
//  TabView.swift
//  CommonWallet
//

import SwiftUI

struct MainTabView: View {

    @ObservedObject var viewModel = MainTabViewModel()
    private let imageNameProperty = ImageNameProperty()

    var body: some View {
        TabView {
            CommonWalletView(viewModel: CommonWalletViewModel(fireStoreTransactionManager: FireStoreTransactionManager(), fireStoreUserManager: FireStoreUserManager()))
                .tabItem {
                    VStack {
                        Image(systemName: imageNameProperty.houseSystemImage)
                        Text("ホーム")
                    }
                }.tag(1)
            AllLogView()
                .tabItem {
                    VStack {
                        Image(systemName: imageNameProperty.trayFullSystemImage)
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
