//
//  CreateUserView.swift
//  CommonWallet
//

import SwiftUI

//struct CreateUserView: View {
//
//    @ObservedObject var createUserViewModel = CreateUserViewModel()
//
//    @State var name = ""
//    @State var mailAdress = ""
//    @State var password = ""
//    @State private var isSecondView: Bool = false
//    @Binding var isShow: Bool
//
//    var body: some View {
//        VStack {
//            Text("アカウント登録")
//            TextField("名前", text: $name)
//            TextField("メールアドレス", text: $mailAdress)
//            TextField("パスワード", text: $password)
//
//            Button(action: {
//
//                Task {
//                    await createUserViewModel.createUser(email: mailAdress, password: password, name: name, complition: { isSuccess, message in
//                        isSecondView = isSuccess
//                        print(isSuccess, message)
//                    })
//                }
//                
//            }) {
//                Text("アカウント登録").fontWeight(.bold).font(.largeTitle)
//            }
//            .fullScreenCover(isPresented: self.$isSecondView) {
//                // trueになれば下からふわっと表示
//                MainTabView()
//            }
//
//            Button {
//                isShow = false
//            } label: {
//                Text("ログインはこちら")
//            }
//        }
//        .padding()
//    }
//}

//struct CreateUserView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateUserView()
//    }
//}

