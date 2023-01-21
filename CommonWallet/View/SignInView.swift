//
//  LoginView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/20.
//

import SwiftUI
import FirebaseAuth

struct SignInView: View {

    @ObservedObject var signInViewModel = SignInViewModel()

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
                    await signInViewModel.signIn(email: mailAdress, password: password, complition:{ isSuccess, message in
                        print(isSuccess, message)
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

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
