//
//  CommonWalletTabView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct CommonWalletView: View {

    @ObservedObject var commonWalletViewModel = CommonWalletViewModel()

    @State var isAccountView = false
    @State var isAddPayInfoView = false

    var body: some View {

        ZStack {

            // 背景色
            Color.white.ignoresSafeArea()

            List {
                VStack {
                    // ヘッダー
                    HeaderAccountView()

                    // パートナーとの差額表示（四角いViewで柔らかい感じに）
                    totalMoneyCardView()
                }

                // 未精算履歴を表示
                Section {
                    ForEach(0 ..< commonWalletViewModel.unpaidPayments.count,  id: \.self) { index in

                        HStack {
                            Text(String(commonWalletViewModel.unpaidPayments[index].cost) + "円")
                            Text(commonWalletViewModel.unpaidPayments[index].title)
                            Spacer() 
                        }
                        .foregroundColor(.black)
                        .contentShape(Rectangle())      // 追加
                        .onTapGesture {
                            print(index)
                        }
                    }

                } header: {
                    Text("未精算リスト")
                }
                .listRowBackground(Color.init(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)))
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)

            // お金追加ボタン
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isAddPayInfoView = true
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
                    .padding(.trailing, 16)
                    .sheet(isPresented: self.$isAddPayInfoView) {
                        AddPayInfoView(isAddPayInfoView: $isAddPayInfoView)
                            .presentationDetents([.large])
                    }
                }
            }
        }
        .onAppear{
            commonWalletViewModel.featchPayments()
        }
    }


    // MARK: - 立替合計金額をカードで表示するView
    private func totalMoneyCardView() -> some View {
        ZStack {
            Rectangle()
                .frame(width: 350, height: 150)
                .foregroundColor(.red)
                .cornerRadius(30)

            VStack {
                Text("\(commonWalletViewModel.payFromName)から\(commonWalletViewModel.payToName)へ")
                    .foregroundColor(.white)
                Text("￥\(commonWalletViewModel.unpaidCost)")
                    .foregroundColor(.white)
            }
        }
    }

}

struct CommonWalletTabView_Previews: PreviewProvider {
    static var previews: some View {
        CommonWalletView()
    }
}
