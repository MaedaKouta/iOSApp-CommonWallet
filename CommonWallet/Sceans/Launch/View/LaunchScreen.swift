//
//  LaunchScreen.swift
//  CommonWallet
//
// 参考: https://thwork.net/2021/11/29/swift_app_launch/
// Info.plistに書く方法もあるが、Firebaseの初期データ取得を行うために、今回は行わないことにした。

import SwiftUI
import FirebaseAuth

struct LaunchScreen: View {

    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var transactionData: TransactionData
    @State private var isSignInView = false
    @State private var isContentView = false

    @State private var isMainTabViewLoading = true
    @State private var isSignInViewLoading = true

    @State private var userDefaultsManager = UserDefaultsManager()
    @State private var fireStoreUserManager = FireStoreUserManager()
    @State private var fireStorePartnerManager = FireStorePartnerManager()

    @ObservedObject var launchViewModel = LaunchViewModel()

    var body: some View {

        if let _ = Auth.auth().currentUser?.uid {
            if isMainTabViewLoading {
                ZStack {
                    Color(.white)
                        .ignoresSafeArea() // ステータスバーまで塗り潰すために必要
                    Image("SampleLogo")
                }
                .onAppear {

                    print("アカウント作成済み")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            isMainTabViewLoading = false
                        }
                    }
                }
            } else {
                MainTabView()
            }

        } else {

            if isSignInViewLoading {
                ZStack {
                    Color(.red)
                        .ignoresSafeArea() // ステータスバーまで塗り潰すために必要
                    Image("Sample1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            isSignInViewLoading = false
                        }
                    }
                }
            } else {

                MainTabView()
            }
        }
    }
}

struct InitialScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
