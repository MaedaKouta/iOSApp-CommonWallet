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

    init() {
        UITableView.appearance().isScrollEnabled = false
    }

    var body: some View {

        ZStack {

            ScrollView(.vertical, showsIndicators: false) {

                // 背景色
                Color.white.ignoresSafeArea()

                VStack {
                    // ヘッダー
                    HStack {
                        Text("12月22日 日曜日")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                            .padding(16)
                        Spacer()
                    }.frame(height: 16, alignment: .topLeading)
                    HStack {
                        Text("こんばんは")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(16)
                        Spacer()
                        Button ( action: {
                            isAccountView = true
                        }) {
                            Image("SampleIcon")
                                .resizable()
                                .scaledToFill()
                                .overlay(RoundedRectangle(cornerRadius: 75).stroke(Color.gray, lineWidth: 1))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36, height: 36, alignment: .center)
                                .clipShape(Circle()) // 正円形に切り抜く
                                .padding(.trailing, 16)
                        }
                        .sheet(isPresented: self.$isAccountView) {
                            // trueになれば下からふわっと表示
                            SettingView()
                        }
                    }

                    // パートナーとの差額表示（四角いViewで柔らかい感じに）
                    ZStack {
                        Rectangle()
                            .frame(width: 350, height: 150)
                            .foregroundColor(.red)
                            .cornerRadius(30)

                        VStack {
                            Text("〇〇から〇〇へ")
                                .foregroundColor(.white)
                            Text("￥\(commonWalletViewModel.unpaidCost)")
                                .foregroundColor(.white)
                        }
                    }

                    // Listで履歴を表示
                    List {
                        Section {
                            ForEach(0 ..< commonWalletViewModel.unpaidPayments.count,  id: \.self) { index in
                                Button(action: {

                                }, label: {
                                    HStack {
                                        Text(String(commonWalletViewModel.unpaidPayments[index].cost) + "円")
                                        Text(commonWalletViewModel.unpaidPayments[index].title)
                                    }.foregroundColor(.black)
                                }
                                )}
                        } header: {
                            Text("未精算")
                        }.listRowBackground(Color.init(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)))

                        Section {
                            ForEach(0 ..< commonWalletViewModel.paidPayments.count,  id: \.self) { index in
                                Button(action: {

                                }, label: {
                                    HStack {
                                        Text(String(commonWalletViewModel.paidPayments[index].cost) + "円")
                                        Text(commonWalletViewModel.paidPayments[index].title)
                                    }.foregroundColor(.black)
                                }
                                )}
                        } header: {
                            Text("精算済み")
                        }.listRowBackground(Color.cyan)
                    }
                    .scrollContentBackground(.hidden)
                    // 下の一文でScrollViewの中でもListが表示できる
                    .scaledToFit()
                }
            }

            // お金追加ボタン
            VStack {
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
                }).sheet(isPresented: self.$isAddPayInfoView) {
                    AddPayInfoView(isAddPayInfoView: $isAddPayInfoView)
                        .presentationDetents([.large])
                }
            }
        }.onAppear{
            commonWalletViewModel.featchPayments()
        }
    }
}

struct CommonWalletTabView_Previews: PreviewProvider {
    static var previews: some View {
        CommonWalletView()
    }
}
