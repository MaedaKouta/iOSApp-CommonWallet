//
//  CommonWalletTabView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct CommonWalletView: View {

    @ObservedObject var commonWalletViewModel: CommonWalletViewModel

    @State var isAccountView = false
    @State var isAddTransactionView = false

    private let cancelButtonSystemImage = "arrow.uturn.backward.circle"
    private let resolveButtonSystemImage = "checkmark.circle"
    private let addTransactionButtonSystemImage = "plus"

    var body: some View {

        NavigationView {
            ZStack {

                // 背景色
                Color.white.ignoresSafeArea()

                List {
                    // パートナーとの差額View
                    VStack {
                        totalMoneyCardView()
                    }.listRowSeparator(.hidden)

                    // 未精算リスト上部のView
                    HStack(spacing: 15) {
                        Text("未精算リスト")
                            .font(.title2)
                        Spacer()
                        cancelTransactionButton()
                        resolveTransactionButton()
                    }
                    .padding(0)
                    .listRowSeparator(.hidden)

                    // 未精算履歴のView
                    if commonWalletViewModel.unResolvedTransactions.count != 0 {
                         // 未精算のものがあればリスト表示
                        unResolvedListView()
                    } else {
                        // 未精算のものがなければ画像表示
                        unResolvedListIsNullView()
                    }

                }
                .listRowSeparator(.hidden)
                .listStyle(.grouped)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .refreshable {
                    await Task.sleep(1000000000)
                }

                // お金追加ボタン
                addTransactionButton()

            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    print("aa")
                }) {
                    //Image(systemName: "trash")
                    Text("こんばんは")
                        .foregroundColor(Color.black)
                        .font(.title3)

                }, trailing: HStack {
                    Button(action: {
                        print("aa")
                    }) {
                        Image("SampleIcon")
                            .resizable()
                            .scaledToFill()
                            .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28, alignment: .center)
                            .clipShape(Circle()) // 正円形に切り抜く
                        Text("kota")
                            .foregroundColor(Color.black)
                    }
                }
            )
        }
        .onAppear{
            self.fetchTransactions()
        }
    }

    // MARK: View
    /// 立替合計金額をカードで表示するView
    private func totalMoneyCardView() -> some View {
        ZStack {
            Rectangle()
                .frame(width: 350, height: 150)
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.black, lineWidth: 5))
                .foregroundColor(.white)
                .cornerRadius(30)

            VStack {
                HStack(spacing: 5) {
                    Text("\(commonWalletViewModel.payFromName)")
                        .foregroundColor(.black)
                    Text("から")
                        .foregroundColor(.gray)
                    Text("\(commonWalletViewModel.payToName)")
                        .foregroundColor(.black)
                    Text("へ")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.leading, 30)

                HStack {
                    Text("￥")
                        .foregroundColor(.black)
                        .baselineOffset(-5)
                    Text("\(commonWalletViewModel.unResolvedAmount)")
                        .font(.title)
                        .foregroundColor(.black)
                }.padding()
            }
        }
        // 下の1行でListをアイコンボタンしかタップできなくしている
        .buttonStyle(BorderlessButtonStyle())
    }

    /// Transaction追加ボタンのView
    private func addTransactionButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    isAddTransactionView = true
                }, label: {
                    Image(systemName: addTransactionButtonSystemImage)
                        .font(.title2)
                        .frame(width: 36.0, height: 36)
                        .padding(8)
                        .accentColor(Color.black)
                        .background(Color.white)
                        .cornerRadius(26)
                        .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
                })
                .padding(.trailing, 16)
                .sheet(isPresented: self.$isAddTransactionView) {
                    AddTransactionView(addTransactionViewModel: AddTransactionViewModel(fireStoreTransactionManager: commonWalletViewModel.getFireStoreTransactionManager(), userDefaultsManager: commonWalletViewModel.getUserDefaultsManager()), commonWalletViewModel: self.commonWalletViewModel, isAddTransactionView: $isAddTransactionView)
                        .presentationDetents([.large])
                }
            }
            .padding()
        }
    }

    /// トランザクション取り消しボタンのView
    private func cancelTransactionButton() -> some View {
        Button(action: {
            Task {
                self.pushResolvedTransaction()
            }
        }, label: {
            HStack(spacing: 3) {
                Image(systemName: cancelButtonSystemImage)
                    .font(.caption)
                Text("取消")
                    .font(.caption)
            }
            .frame(width: 60.0, height: 20.0)
            .padding(8)
            .accentColor(Color.black)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.gray, radius: 3, x: 0, y: 0)
        })

    }

    /// 精算ボタンのView
    private func resolveTransactionButton() -> some View {
        Button(action: {
            Task {
                self.pushResolvedTransaction()
            }
        }, label: {
            HStack(spacing: 3) {
                Image(systemName: resolveButtonSystemImage)
                    .font(.caption)
                Text("精算")
                    .font(.caption)
            }
            .frame(width: 60.0, height: 20.0)
            .padding(8)
            .accentColor(Color.black)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.gray, radius: 3, x: 0, y: 0)
        })
    }

    /// 未精算リストView
    private func unResolvedListView() -> some View {
        Section {
            ForEach(0 ..< commonWalletViewModel.unResolvedTransactions.count,  id: \.self) { index in
                HStack {
                    Image("SampleIcon")
                        .resizable()
                        .scaledToFill()
                        .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28, alignment: .center)
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text("2023/4/6")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                        Text(commonWalletViewModel.unResolvedTransactions[index].title)
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text("¥\(commonWalletViewModel.unResolvedTransactions[index].amount)")
                    }

                }
                .padding(3)
                .foregroundColor(.black)
                .contentShape(Rectangle())
                .onTapGesture {
                    print(index)
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.white)
        }
        .listRowBackground(Color.init(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)))
    }

    private func unResolvedListIsNullView() -> some View {
        VStack {
            Image("Sample2")
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fit)
                .padding(.top)
            Text("リストが空です")
                .foregroundColor(.gray)
        }
        .listRowSeparator(.hidden)
        .padding(.top, 100)
    }

    // MARK: 通信系
    private func fetchTransactions() {
        Task{
            try await commonWalletViewModel.fetchTransactions()
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

//struct CommonWalletTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommonWalletView()
//    }
//}
