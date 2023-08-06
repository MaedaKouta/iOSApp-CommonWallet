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

    @ObservedObject var viewModel = LaunchViewModel()

    var body: some View {

        // 既に匿名ログインが済んでいる場合
        if Auth.auth().currentUser?.uid != nil {
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

        // 匿名ログインが済んでいない場合
        } else {
            if isSignInViewLoading {
                ZStack {
                    Color(.red)
                        .ignoresSafeArea() // ステータスバーまで塗り潰すために必要
                    Text("アカウント作成中...")
                    Image("Sample1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
                .onAppear {
                    // アカウント作成
                    Task {
                        do {
                            // ユーザーとパートナーの名前初期値はとりあえずここで定義
                            try await viewModel.createUser(myUserName: "ユーザー", partnerUserName: "パートナー")
                            print("アカウント作成しました！")
                        } catch {
                            print(#function, error)
                        }
                    }

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
