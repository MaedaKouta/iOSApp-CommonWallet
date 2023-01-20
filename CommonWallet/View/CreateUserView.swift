//
//  CreateUserView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/20.
//

import SwiftUI

struct CreateUserView: View {
    @State var name = ""
    @State var mailAdress = ""
    @State var password = ""
    @State private var isSecondView: Bool = false
    @Binding var isShow: Bool
    let authManager = AuthManager()

    var body: some View {
        VStack {
            Text("アカウント登録")
            TextField("名前", text: $name)
            TextField("メールアドレス", text: $mailAdress)
            TextField("パスワード", text: $password)

            Button(action: {

//                authManager.createUser(email: mailAdress, password: password, name: name, complition: { isSuccess, message in
//                    isSecondView = isSuccess
//                    print("認証状況：", isSuccess, message)
//                })
            }) {
                Text("アカウント登録").fontWeight(.bold).font(.largeTitle)
            }
            .sheet(isPresented: self.$isSecondView) {
                // trueになれば下からふわっと表示
                ContentView()
            }

            Button {
                isShow = false
            } label: {
                Text("ログインはこちら")
            }
        }
        .padding()
    }
}

//struct CreateUserView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateUserView()
//    }
//}

