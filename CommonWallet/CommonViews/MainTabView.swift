//
//  TabView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import SwiftUI

struct MainTabView: View {

    var body: some View {
        TabView {
            CommonWalletView()
                .tabItem {
                    VStack {
                        Image(systemName: "a")
                        Text("TabA")
                    }
                }.tag(1)
            LogView()
                .tabItem {
                    VStack {
                        Image(systemName: "a")
                        Text("TabB")
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
