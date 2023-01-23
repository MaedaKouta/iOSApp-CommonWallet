//
//  AccountView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct AccountView: View {
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
                    Text("サインアウト")
                }

                Section {
                    Text("アカウント削除")
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
