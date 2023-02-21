//
//  AccountView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct AccountView: View {
    
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
                .listRowBackground(Color.init(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)))

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
                .listRowBackground(Color.init(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)))

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
                .listRowBackground(Color.init(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)))
            }
            .navigationTitle("アカウント")
            //.navigationBarTitleDisplayMode(.inline)

        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
