//
//  AccountView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct AccountView: View {

    @Binding var isShowSettingView: Bool
    let authManager = AuthManager()
    @State var fireStoreUserManager = FireStoreUserManager()
    @ObservedObject var accountViewModel = AccountViewModel()

    var body: some View {
        VStack {

            List {
                Section {

                    HStack {
                        Text("アイコン")
                        NavigationLink(destination: {
                            // TODO: 今はとりあえずContentView
                            ContentView()
                        }, label: {
                            Text("編集する")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        })
                    }

                    HStack {
                        Text("ユーザー名")

                        NavigationLink(destination: {
                            // TODO: 今はとりあえずContentView
                            ContentView()
                        }, label: {
                            Text(accountViewModel.userName)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        })
                    }

                    HStack {
                        Text("メール")

                        NavigationLink(destination: {
                            // TODO: 今はとりあえずContentView
                            ContentView()
                        }, label: {
                            Text(accountViewModel.userEmail)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        })
                    }

                    HStack {
                        Text("パスワード")

                        NavigationLink(destination: {
                            // TODO: 今はとりあえずContentView
                            ContentView()
                        }, label: {
                            Text("******")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        })
                    }
                }

                Section {
                    Button(action: {
                        Task {
                            do {
                                try await authManager.signOut()
                            } catch {
                                print("サインアウト失敗", error)
                            }
                        }
                    }) {
                        Text("サインアウト")
                    }
                }

                Section {
                    Button(action: {
                        Task {
                            do {
                                try await authManager.deleteUser()
                            } catch {
                                print("アカウント削除", error)
                            }
                        }
                    }) {
                        Text("アカウント削除")
                    }
                }

            }// Listここまで
            .scrollContentBackground(.visible)
            .navigationTitle("アカウント")
            .toolbar {
                /// ナビゲーションバー左
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {isShowSettingView = false}) {
                        Text("完了")
                    }
                }
            }

        }
    }
}

//struct AccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountView()
//    }
//}
