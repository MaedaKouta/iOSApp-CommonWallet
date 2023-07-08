//
//  LoginView.swift
//  CommonWallet
//

//import SwiftUI
//import FirebaseAuth
//
//struct SignInView: View {
//
//    @ObservedObject var signInViewModel = SignInViewModel()
//
//    @State var email = ""
//    @State var password = ""
//    @State private var isSecondView: Bool = false
//    @State private var isCreateUserView: Bool = false
//
//    var body: some View {
//        VStack {
//            Text("ログイン")
//            TextField("メールアドレス", text: $email)
//            TextField("パスワード", text: $password)
//
//            Button(action: {
//                Task {
//                    await signInViewModel.signIn(email: email, password: password, complition:{ isSuccess, message in
//                        print(isSuccess, message)
//                    })
//                }
//            }) {
//                Text("ログイン").fontWeight(.bold).font(.largeTitle)
//            }
//            .fullScreenCover(isPresented: self.$isSecondView) {
//                MainTabView()
//            }
//
//            Button {
//                isCreateUserView.toggle()
//            } label: {
//                Text("アカウント登録はこちら")
//            }
//            .fullScreenCover(isPresented: $isCreateUserView) {
//                //CreateUserView(isShow: $isCreateUserView)
//            }
//        }
//        .padding()
//    }
//
//}
//
//struct SignInView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInView()
//    }
//}
