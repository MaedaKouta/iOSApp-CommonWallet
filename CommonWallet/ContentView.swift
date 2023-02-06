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
            Text(user?.email ?? "")

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

            Button(action: {
                Task {
                    do {
                        try await authManager.deleteUser()
                    } catch {
                        print("アカウント削除失敗", error)
                    }
                }
            }) {
                Text("アカウント削除")
            }

        }
        .padding()
        .onAppear {
            Task {
                let uid = Auth.auth().currentUser!.uid
                fireStoreUserManager.fetchUser(uid: uid, completion: { userr, error in
                    if let user = userr {
                        self.user = user
                    }
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
