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

    var body: some View {
        VStack {
            List {
                Section {
                    Text("アイコン")
                    Text("ユーザー名")
                    Text("メールアドレス")
                    Text("パスワード")
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
