//
//  ContentView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/20.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    let authManager = AuthManager()
    @State var fireStoreUserManager = FireStoreUserManager()
    @State var user: User?

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")

            Text(user?.uid ?? "")
            Text(user?.userName ?? "")
            Text(user?.mailAdress ?? "")

            Button(action: {
                Task {
//                    await authManager.signOut(complition: { isSuccess, message in
//                        if isSuccess {
//                            print("サインアウト成功！", message)
//                        } else {
//                            print("サインアウト失敗", message)
//                        }
//                    })
                }
            }) {
                Text("サインアウト")
            }

            Button(action: {
                Task {
//                    await authManager.deleteUser(complition: { isSuccess, message in
//                        if isSuccess {
//                            print("アカウント削除成功！", message)
//                        } else {
//                            print("アカウント削除失敗", message)
//                        }
//                    })
                }
            }) {
                Text("アカウント削除")
            }

        }
        .padding()
        .onAppear {
            Task {
                do {
                    let uid = Auth.auth().currentUser!.uid
                    user = try await fireStoreUserManager.fetchUser(uid: uid)
                } catch {
                    print("adfdafadfaf")
                }
                //self.userDefaultsManager.setUser(user: user)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
