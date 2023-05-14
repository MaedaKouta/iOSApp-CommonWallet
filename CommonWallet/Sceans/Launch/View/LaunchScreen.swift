//
//  LaunchScreen.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/22.
//
// 参考: https://thwork.net/2021/11/29/swift_app_launch/
// Info.plistに書く方法もあるが、Firebaseの初期データ取得を行うために、今回は行わないことにした。

import SwiftUI
import FirebaseAuth

struct LaunchScreen: View {

    @Environment(\.managedObjectContext) private var viewContext
    @State private var isSignInView = false
    @State private var isContentView = false
    @State private var userDefaultsManager = UserDefaultsManager()
    @State private var fireStoreUserManager = FireStoreUserManager()
    @State private var fireStorePartnerManager = FireStorePartnerManager()

    @ObservedObject var launchViewModel = LaunchViewModel()

    var body: some View {

        ZStack {

            Color.black.ignoresSafeArea()

            VStack {
                Text("LaunchScreen")
                    .foregroundColor(.white)
                    .padding()
                    .onAppear {
                        if let _ = Auth.auth().currentUser?.uid {
                            // サインインがすでにされている処理分岐
                            Task {
                                await fireStorePartnerManager.fetchDeletePartner()
                            }

                            // ここでは、アニメーション無しで画面遷移させている
//                            var transaction = Transaction()
//                            transaction.disablesAnimations = true
//                            withTransaction(transaction) {
                                isContentView = true
                            //}
                        } else {
                            // サインインがされていない処理分岐
                            // とりあえず、チュートリアル画面作成していないため、サインイン画面に全て流す
                            // ここでは、アニメーション無しで画面遷移させている
//                            var transaction = Transaction()
//                            transaction.disablesAnimations = true
//                            withTransaction(transaction) {
                                isSignInView = true
//                            }

                            switch LaunchStatus.launchStatus {
                            case .FirstLaunch :
                                // 初回起動
                                return
                            case .NewVersionLaunch :
                                // 新しいバージョン時の起動
                                return
                            case .Launched:
                                // 通常の起動
                                break
                            }

                        }
                    }
                    .fullScreenCover(isPresented: self.$isSignInView){
                        SignInView()
                    }
                    .fullScreenCover(isPresented: self.$isContentView){
                        MainTabView()
                    }
            }
        }.onAppear {
            Task {
                try await launchViewModel.fetchOldestDate()
                try await launchViewModel.fetchUserInfo()
            }
        }

    }
}

struct InitialScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
