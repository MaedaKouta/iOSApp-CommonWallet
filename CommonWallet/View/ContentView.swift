//
//  ContentView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/20.
//

import SwiftUI

struct ContentView: View {
    let authManager = AuthManager()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")

            Button(action: {
                Task {
                    await authManager.signOut(complition: { isSuccess, message in
                        if isSuccess {
                            print("サインアウト成功！", message)
                        } else {
                            print("サインアウト失敗", message)
                        }
                    })
                }
            }) {
                Text("サインアウト")
            }

            Button(action: {
                Task {
                    await authManager.deleteUser(complition: { isSuccess, message in
                        if isSuccess {
                            print("アカウント削除成功！", message)
                        } else {
                            print("アカウント削除失敗", message)
                        }
                    })
                }
            }) {
                Text("アカウント削除")
            }

            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
