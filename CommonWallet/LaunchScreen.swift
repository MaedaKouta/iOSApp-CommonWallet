//
//  LaunchScreen.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/22.
//
// 参考: https://thwork.net/2021/11/29/swift_app_launch/
// Info.plistに書く方法もあるが、Firebaseの初期データ取得を行うために、今回は行わないことにした。

import SwiftUI

struct LaunchScreen: View {

    @Environment(\.managedObjectContext) private var viewContext
    @State var isSignInView = false
    @State var isContentView = false

    var body: some View {
        Text("")
            .padding()
            .onAppear {
                if UserStatusUtil.isSignedIn {
                    // サインインがすでにされている処理分岐
                    isContentView = true
                } else {
                    // サインインがされていない処理分岐
                    // とりあえず、チュートリアル画面作成していないため、サインイン画面に全て流す
                    isSignInView = true

                    switch LaunchStatusUtil.launchStatus {
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
            .sheet(isPresented: self.$isSignInView){
                SignInView()
            }
            .sheet(isPresented: self.$isContentView){
                ContentView()
            }
    }
}

struct InitialScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
