//
//  CommonWalletTabView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct CommonWalletView: View {

    @ObservedObject var commonWalletViewModel: CommonWalletViewModel

    // 画面遷移
    @State var isSettingView = false
    @State var isAddTransactionView = false
    @State var isEditTransactionView = false

    // カードViewをめくる変数
    @State var isCardViewFront = true

    // アラート
    @State var isResolveAlert = false
    @State var isEnableResolveButton = false
    @State var isCancelAlert = false
    @State var isTransactionDescriptionAlert = false
    @State var isDeleteTransactionAlert = false

    @State var selectedTransactionIndex = 0
    @State var selectedDeleteTransactionIndex = 0
    @State var selectedEditTransactionIndex = 0

    // 画像のSystemImage
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
                        Flip(isFront: isCardViewFront, // 先に作っておいた変数 isFront
                             front: {
                            moneyAmountCardFrontView() // 表面
                        },
                             back: {
                            moneyAmountCardBackView() // 裏面
                        })
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .listRowSeparator(.hidden)

                    // 未精算リスト上部のView
                    HStack(alignment: .bottom, spacing: 15) {
                        Text("未精算リスト")
                            .font(.title2)
                        Spacer()
                        resolveTransactionButton()
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.top, 5)

                    // 未精算履歴のView
                    if commonWalletViewModel.unResolvedTransactions.count != 0 {
                         // 未精算のものがあればリスト表示
                        unResolvedListView()
                            .onAppear {
                                isEnableResolveButton = true
                            }
                    } else {
                        // 未精算のものがなければ画像表示
                        unResolvedListIsNullView()
                            .onAppear {
                                isEnableResolveButton = false
                            }
                    }

                }
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
                        self.isSettingView = true
                    }) {
                        Image(uiImage: commonWalletViewModel.myIconImage)
                            .resizable()
                            .scaledToFill()
                            .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28, alignment: .center)
                            .clipShape(Circle()) // 正円形に切り抜く
                        Text(commonWalletViewModel.myName)
                            .foregroundColor(Color.black)
                    }
                    .sheet(isPresented: self.$isSettingView) {
                        SettingView(isShowSettingView: $isSettingView)
                    }
                }
            )
        }
        .onAppear{
            self.fetchTransactions()
        }
    }

    // MARK: View
    /// 立替合計金額をカードで表示する表側のView
    private func moneyAmountCardFrontView() -> some View {
        ZStack {
            Rectangle()
                .frame(width: 350, height: 150)
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.black, lineWidth: 4))
                .foregroundColor(.white)
                .cornerRadius(30)

            VStack {
                Spacer()
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
                }.padding(.leading, 30)

                Spacer()

                HStack {
                    Text("￥")
                        .foregroundColor(.black)
                        .baselineOffset(-5)
                    Text("\(commonWalletViewModel.unResolvedAmount)")
                        .font(.title)
                        .foregroundColor(.black)
                }

                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        isCardViewFront.toggle()
                    }, label: {
                        Image(systemName: "hand.tap")
                            .foregroundColor(.black)
                    })

                }.padding(.horizontal, 30)
                Spacer()

            }
        }
    }

    /// 立替合計金額をカードで表示する表側のView
    private func moneyAmountCardBackView() -> some View {
        ZStack {
            Rectangle()
                .frame(width: 350, height: 150)
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.black, lineWidth: 4))
                .foregroundColor(.white)
                .cornerRadius(30)

            VStack() {
                Spacer()

                HStack {
                    Text("未精算の立て替え総額")
                    Spacer()
                }
                .foregroundColor(.gray)
                .padding()

                VStack() {
                    Text("User2  ¥0")
                    Text("Ttest1  ¥0")
                }
                .foregroundColor(.black)
                .padding([.leading, .trailing])

                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        isCardViewFront.toggle()
                    }, label: {
                        Image(systemName: "hand.tap")
                            .foregroundColor(.black)
                    })

                }.padding(.horizontal, 30)
                Spacer()

            }
        }
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
                    AddTransactionView(
                        addTransactionViewModel: AddTransactionViewModel(fireStoreTransactionManager: commonWalletViewModel.getFireStoreTransactionManager(), userDefaultsManager: commonWalletViewModel.getUserDefaultsManager()),
                        commonWalletViewModel: self.commonWalletViewModel,
                        isAddTransactionView: $isAddTransactionView
                    )
                    .presentationDetents([.large])
                }
                .sheet(isPresented: self.$isEditTransactionView) {
                    EditTransactionView(
                        editTransactionViewModel: EditTransactionViewModel(fireStoreTransactionManager: commonWalletViewModel.getFireStoreTransactionManager(), userDefaultsManager: commonWalletViewModel.getUserDefaultsManager(), transaction: commonWalletViewModel.unResolvedTransactions[self.selectedEditTransactionIndex]),
                        commonWalletViewModel: self.commonWalletViewModel,
                        isEditTransactionView: $isEditTransactionView
                    )
                    .presentationDetents([.large])
                } // sheetここまで

            }
            .padding()
        }
    }

    /// 精算ボタンのView
    private func resolveTransactionButton() -> some View {

        Button(action: {
            self.isResolveAlert = true
        }, label: {
            HStack(spacing: 3) {
                Image(systemName: resolveButtonSystemImage)
                    .font(.caption)
                Text("精算")
                    .font(.caption)
            }
            .frame(width: 80.0, height: 20.0)
            .padding(8)
            .accentColor(Color.black)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.gray, radius: 3, x: 0, y: 0)
        })
        .disabled(!isEnableResolveButton)
        .alert("精算", isPresented: $isResolveAlert){
            Button("キャンセル"){
                // ボタン1が押された時の処理
            }
            Button("OK"){
                Task {
                    self.pushResolvedTransaction()
                }
            }
        } message: {
            Text("精算しますか？")
        }
    }

    /// 未精算リストView
    private func unResolvedListView() -> some View {
        ForEach(0 ..< commonWalletViewModel.unResolvedTransactions.count,  id: \.self) { index in

            HStack {

                if commonWalletViewModel.unResolvedTransactions[index].debtorId != commonWalletViewModel.myUserId {
                    Image(uiImage: commonWalletViewModel.myIconImage)
                        .resizable()
                        .scaledToFill()
                        .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28, alignment: .center)
                        .clipShape(Circle())
                } else {
                    Image(uiImage: commonWalletViewModel.partnerIconImage)
                        .resizable()
                        .scaledToFill()
                        .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28, alignment: .center)
                        .clipShape(Circle())
                }

                VStack(alignment: .leading) {
                    Text(self.dateToString(date: commonWalletViewModel.unResolvedTransactions[index].createdAt))
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
                self.selectedTransactionIndex = index
                self.isTransactionDescriptionAlert = true
            }
            .alert("\(commonWalletViewModel.unResolvedTransactions[self.selectedTransactionIndex].title)", isPresented: $isTransactionDescriptionAlert){
                Button("OK") {
                }
            } message: {
                let amount = commonWalletViewModel.unResolvedTransactions[self.selectedTransactionIndex].amount
                let description = commonWalletViewModel.unResolvedTransactions[self.selectedTransactionIndex].description
                let createdAt = self.dateToDetailString(date: commonWalletViewModel.unResolvedTransactions[self.selectedTransactionIndex].createdAt)
                let debtor = commonWalletViewModel.unResolvedTransactions[self.selectedTransactionIndex].debtorId == commonWalletViewModel.partnerUserId ? commonWalletViewModel.myName : commonWalletViewModel.partnerName

                if description.isEmpty {
                    Text("""
                        ¥\(amount)
                        「\(debtor)」が立て替え
                        \(createdAt)
                        """)
                } else {
                    Text("""
                        ¥\(amount)
                        「\(debtor)」が立て替え
                        \(createdAt)
                        \(description)
                        """)
                }
            } // alertここまで
            .swipeActions(edge: .trailing, allowsFullSwipe: false)  {
                Button(role: .none) {
                    self.selectedDeleteTransactionIndex = index
                    self.isDeleteTransactionAlert = true
                } label: {
                    Image(systemName: "trash.fill")
                }
                .tint(.red)

                Button(role: .none) {
                    self.selectedEditTransactionIndex = index
                    self.isEditTransactionView = true
                } label: {
                    Image(systemName: "pencil")
                }
                .tint(.orange)
            }
            .alert("注意", isPresented: $isDeleteTransactionAlert){
                Button("キャンセル") {
                }
                Button("OK") {
                    self.deleteTransaction(transactionId: commonWalletViewModel.unResolvedTransactions[self.selectedDeleteTransactionIndex].id)
                }
            } message: {
                Text("削除して良いですか？")
            } // alertここまで
        }
    }

    private func unResolvedListIsNullView() -> some View {
        VStack {
            Image("Sample2")
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fit)
                .padding(.top)
                .transition(.opacity)

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

    private func deleteTransaction(transactionId: String) {
        Task{
            do {
                // ここでindexを0にしないと、out of range になる
                self.selectedDeleteTransactionIndex = 0
                self.selectedTransactionIndex = 0
                try await commonWalletViewModel.deleteTransaction(transactionId: transactionId)
            } catch {
                print("transactionの削除に失敗：", error)
            }
        }
    }

    private func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy/MM/dd"

        return dateFormatter.string(from: date)
    }

    private func dateToDetailString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"

        return dateFormatter.string(from: date)
    }

}

//struct CommonWalletTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommonWalletView()
//    }
//}
