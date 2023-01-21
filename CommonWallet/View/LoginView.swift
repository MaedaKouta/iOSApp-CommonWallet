//
//  LoginView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/20.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State var mailAdress = ""
    @State var password = ""
    @State private var isSecondView: Bool = false
    @State private var isCreateUserView: Bool = false
    let authManager = AuthManager()

    var body: some View {
        VStack {
            Text("ログイン")
            TextField("メールアドレス", text: $mailAdress)
            TextField("パスワード", text: $password)

            Button(action: {
                Task {
                    await authManager.login(email: mailAdress, password: password, complition: { isSuccess, message in
                        isSecondView = isSuccess
                        print("認証状況：", isSuccess, message)
                    })
                }
            }) {
                Text("ログイン").fontWeight(.bold).font(.largeTitle)
            }
            .sheet(isPresented: self.$isSecondView) {
                // trueになれば下からふわっと表示
                ContentView()
            }

            Button {
                isCreateUserView.toggle()
            } label: {
                Text("アカウント登録はこちら")
            }
            .sheet(isPresented: $isCreateUserView) {
                CreateUserView(isShow: $isCreateUserView)
            }
        }
        .padding()

        .onAppear {
            print("here")
            // uidが存在するならMainViewへ移動
            if let uid = Auth.auth().currentUser?.uid {
                print("uid:",uid)
                isSecondView = true
            }
        }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
