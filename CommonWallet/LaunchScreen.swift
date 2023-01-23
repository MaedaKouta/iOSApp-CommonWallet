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

    var body: some View {
        Text("")
            .padding()
            .onAppear {
                if let uid = Auth.auth().currentUser?.uid {

                    // サインインがすでにされている処理分岐
                    Task {
                        do {
                            let user = try await fireStoreUserManager.fetchUser(uid: uid)
                            isContentView = true
                        } catch {
                            // 一旦例外処理をprint文にしておく
                            print("LaunchScreenのサインインチェックでエラー", error)
                        }
                    }
                } else {
                    // サインインがされていない処理分岐
                    // とりあえず、チュートリアル画面作成していないため、サインイン画面に全て流す
                    isSignInView = true

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
                ContentView()
            }
    }
}

struct InitialScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
