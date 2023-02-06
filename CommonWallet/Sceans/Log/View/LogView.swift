//
//  LogView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import SwiftUI

struct LogView: View {

    @ObservedObject var logViewModel = LogViewModel()

    var body: some View {

        List {
            
            Section {
                VStack {
                    // ヘッダー
                    HeaderLogView()
                }
            }
            
            Section {
                Text("First Item")
                Text("Second Item")
                Text("Third Item")
                Text("First Item")
                Text("Second Item")
                Text("Third Item")
                Text("First Item")
                Text("Second Item")
            } header: {
                HStack {
                    Text("過去1ヶ月")
                    Spacer()
                    Button ( action: {
                        //isAccountView = true
                    }) {
                        Text("全履歴 >")
                    }
//                    .sheet(isPresented: self.$isAccountView) {
//                        // trueになれば下からふわっと表示
//                        SettingView()
//                    }

                }
            }
            .listRowBackground(Color.init(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)))
        }
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)

    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
