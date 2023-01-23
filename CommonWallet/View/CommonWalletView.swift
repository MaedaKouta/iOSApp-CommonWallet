//
//  CommonWalletTabView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct CommonWalletView: View {


    var body: some View {
        ZStack {

            // 背景色
            Color.white.ignoresSafeArea()

            VStack {

                // ユーザー情報系
                HStack {
                    Image(systemName: "globe")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }.padding()

                // パートナーとの差額表示（四角いViewで柔らかい感じに）
                Rectangle()
                    .frame(width: 350, height: 150)
                    .foregroundColor(.red)
                    .cornerRadius(30)

                // Listで履歴を表示
                List {
                    Section {
                        Text("2/26 5000円 相手")
                        Text("2/23 250円 自分")
                        Text("2/22 3000円 相手")
                    } header: {
                        Text("未精算")
                    }
                    Section {
                        Text("1/26 5000円 相手")
                        Text("1/23 250円 自分")
                        Text("1/22 3000円 相手")
                    } header: {
                        Text("精算済み")
                    }
                }
            }

            // お金追加ボタン
            VStack {
                Spacer()
                Button(action: {

                }, label: {
                    Text("＋")
                        .frame(width: 35.0, height: 35.0)
                        .padding(8)
                        .accentColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(25)
                        .shadow(color: Color.white, radius: 10, x: 0, y: 3)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                })
            }
            
        }
    }
}

struct CommonWalletTabView_Previews: PreviewProvider {
    static var previews: some View {
        CommonWalletView()
    }
}
