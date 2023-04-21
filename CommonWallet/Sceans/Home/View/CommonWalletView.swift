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
    @State var isAddTransactionView = false

    var body: some View {

        ZStack {

            // 背景色
            Color.white.ignoresSafeArea()

            List {
                VStack {
                    // ヘッダー
                    HeaderHomeView()

                    // パートナーとの差額表示（四角いViewで柔らかい感じに）
                    totalMoneyCardView()
                }

                // 未精算履歴を表示
                Section {
                    ForEach(0 ..< commonWalletViewModel.unResolvedTransactions.count,  id: \.self) { index in

                        HStack {
                            Text(String(commonWalletViewModel.unResolvedTransactions[index].amount) + "円")
                            Text(commonWalletViewModel.unResolvedTransactions[index].title)
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
                        isAddTransactionView = true
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
                    .sheet(isPresented: self.$isAddTransactionView) {
                        AddTransactionView(isAddTransactionView: $isAddTransactionView)
                            .presentationDetents([.large])
                    }
                }
                .padding()
            }
        }
        .onAppear{
            self.fetchTransactions()
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
                Text("￥\(commonWalletViewModel.unResolvedAmount)")
                    .foregroundColor(.white)

                // 本来は精算ボタンタップ後にアラート表示で完了させよう
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            self.pushResolvedTransaction()
                        }
                    }, label: {
                        Text("> 精算")
                            .foregroundColor(.white)
                    })
                    .padding(.trailing, 16)
                }
            }
        }
        // 下の1行でListをアイコンボタンしかタップできなくしている
        .buttonStyle(BorderlessButtonStyle())
    }

    private func fetchTransactions() {
        Task{

            let result = try await commonWalletViewModel.fetchTransactions()

            switch result {
            case .success:
                // 成功した場合の処理
                print("CommonWalletView：Transactionのfetch成功")
                break
            case .failure(let error):
                // 失敗した場合の処理
                print("CommonWalletView：Transactionのfetch失敗")
                print("CommonWalletView：Transaction failed with error: \(error.localizedDescription)")
                break
            }
        }
    }

    private func pushResolvedTransaction() {
        Task{

            let result = try await commonWalletViewModel.pushResolvedTransaction()

            switch result {
            case .success:
                // 成功した場合の処理
                print("CommonWalletView：pushResolvedTransactionの登録成功")
                break
            case .failure(let error):
                // 失敗した場合の処理
                print("CommonWalletView：pushResolvedTransactionの登録失敗")
                print("CommonWalletView：Transaction failed with error: \(error.localizedDescription)")
                break
            }
        }
    }

}

struct CommonWalletTabView_Previews: PreviewProvider {
    static var previews: some View {
        CommonWalletView()
    }
}
