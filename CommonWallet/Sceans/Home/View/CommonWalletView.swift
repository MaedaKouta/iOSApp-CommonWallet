//
//  CommonWalletTabView.swift
//  CommonWallet
//

import SwiftUI

struct CommonWalletView: View {

    @ObservedObject var viewModel: CommonWalletViewModel
    @EnvironmentObject var selectedEditTransaction: SelectedEditTransaction
    @EnvironmentObject var transactionData: TransactionData
    // バックグラウンドかフォアグラウンドを検知
    @Environment(\.scenePhase) private var scenePhase

    // Userdefaults
    @AppStorage(UserDefaultsKey().userId) private var myUserId = String()
    @AppStorage(UserDefaultsKey().userName) private var myUserName = String()
    @AppStorage(UserDefaultsKey().myIconData) private var myIconData = Data()
    @AppStorage(UserDefaultsKey().partnerUserId) private var partnerUserId = String()
    @AppStorage(UserDefaultsKey().partnerIconData) private var partnerIconData = Data()
    @AppStorage(UserDefaultsKey().partnerModifiedName) private var partnerModifiedName = String()
    @State private var imageNameProperty = ImageNameProperty()

    // 画面遷移
    @State var isSettingView: Bool = false
    @State var isAddTransactionView: Bool = false
    @State var isEditTransactionView: Bool = false
    @State private var greetingText: String = ""
    // カードViewの表裏
    @State var isCardViewFront: Bool = true
    // アラート
    @State var isAllResolveAlert: Bool = false
    @State var isOnlyResolveAlert: Bool = false
    @State var isEnableResolveButton: Bool = false
    @State var isCancelAlert: Bool = false
    @State var isTransactionDescriptionAlert: Bool = false
    @State var isDeleteTransactionAlert: Bool = false
    // セルの選択
    @State var selectedTransactionIndex = 0
    @State var selectedResolveTransactionIndex = 0
    @State var selectedDeleteTransactionIndex = 0
    // PKHUD
    @State private var isPKHUDProgress = false
    @State private var isPKHUDSuccess = false
    @State private var isPKHUDError = false
    // UserDefaults
    @AppStorage(UserDefaultsKey().userId) private var myUserId = String()
    @AppStorage(UserDefaultsKey().userName) private var myUserName = String()
    @AppStorage(UserDefaultsKey().myIconData) private var myIconData = Data()
    @AppStorage(UserDefaultsKey().partnerUserId) private var partnerUserId = String()
    @AppStorage(UserDefaultsKey().partnerModifiedName) private var partnerModifiedName = String()
    @AppStorage(UserDefaultsKey().partnerIconData) private var partnerIconData = Data()
    // 画像のSystemImage
    private let imageNameProperty = ImageNameProperty()

    var body: some View {
        NavigationView {
            ZStack {

                // 背景色
                Color.white.ignoresSafeArea()

                List {
                    // パートナーとの差額View
                    VStack {
                        Flip(isFront: isCardViewFront,
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
                    if transactionData.unResolvedTransactions.count != 0 {
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

                // お金追加ボタン
                addTransactionButton()

            }
            .PKHUD(isPresented: $isPKHUDProgress, HUDContent: .progress, delay: .infinity)
            .PKHUD(isPresented: $isPKHUDSuccess, HUDContent: .success, delay: 0.7)
            .PKHUD(isPresented: $isPKHUDError, HUDContent: .error, delay: 0.7)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                leading: HStack {
                    greetingTextView()
                }, trailing: HStack {
                    Button(action: {
                        self.isSettingView = true
                    }) {
                        Image(uiImage: UIImage(data: myIconData) ?? UIImage(named: imageNameProperty.iconNotFound)!)
                            .resizable()
                            .scaledToFill()
                            .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28, alignment: .center)
                            .clipShape(Circle()) // 正円形に切り抜く
                        Text(myUserName)
                            .foregroundColor(Color.black)
                    }
                    .sheet(isPresented: self.$isSettingView) {
                        SettingView(viewModel: SettingViewModel(userDefaultsManager: UserDefaultsManager()), isShowSettingView: $isSettingView)
                    }
                }
            )
        }
        .animation(.default)
        // フォアグラウンド直前に毎回呼び出される処理
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                self.createGreetingText()
            }
        }
    }

    // MARK: - View
    /**
     立替合計金額をカード表示する表側のView
     - Description
     - 「〇〇から〇〇へ〇〇円」をメインに表示
     */
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
                    if (transactionData.unResolvedAmounts < 0) {
                        Text("\(myUserName)")
                            .foregroundColor(.black)
                        Text("から")
                            .foregroundColor(.gray)
                        Text("\(partnerModifiedName)")
                            .foregroundColor(.black)
                        Text("へ")
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        Text("\(partnerModifiedName)")
                            .foregroundColor(.black)
                        Text("から")
                            .foregroundColor(.gray)
                        Text("\(myUserName)")
                            .foregroundColor(.black)
                        Text("へ")
                            .foregroundColor(.gray)
                        Spacer()
                    }

                }.padding(.leading, 30)

                Spacer()

                HStack {
                    Text("￥")
                        .foregroundColor(.black)
                        .baselineOffset(-5)
                    Text("\(abs(transactionData.unResolvedAmounts))")
                        .font(.title)
                        .foregroundColor(.black)
                }

                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        isCardViewFront.toggle()
                    }, label: {
                        Image(systemName: imageNameProperty.handTapSystemImage)
                            .foregroundColor(.black)
                    })

                }.padding(.horizontal, 30)
                Spacer()
            }
        }
        .animation(.default)
    }

    /**
     立替合計金額をカード表示する裏側のView
     - Description
     - 「〇〇 〇〇円、〇〇 〇〇円」をメインに表示
     */
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
                    Text("\(myUserName) ¥\(transactionData.unResolvedMyAmounts)")
                    Text("\(partnerModifiedName) ¥\(transactionData.unResolvedPartnerAmounts)")
                }
                .foregroundColor(.black)
                .padding([.leading, .trailing])

                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        isCardViewFront.toggle()
                    }, label: {
                        Image(systemName: imageNameProperty.handTapSystemImage)
                            .foregroundColor(.black)
                    })

                }.padding(.horizontal, 30)
                Spacer()
            }
        }
        .animation(.default)
    }

    /**
     立替合計金額をカード表示する裏側のView
     - Description
     - 「〇〇 〇〇円、〇〇 〇〇円」をメインに表示
     */
    private func addTransactionButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    isAddTransactionView = true
                }, label: {
                    Image(systemName: imageNameProperty.plusSystemImage)
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
                        addTransactionViewModel: AddTransactionViewModel(fireStoreTransactionManager: FireStoreTransactionManager(), userDefaultsManager: UserDefaultsManager()),
                        commonWalletViewModel: self.viewModel,
                        isAddTransactionView: $isAddTransactionView
                    )
                    .presentationDetents([.large])
                }
                .sheet(isPresented: self.$isEditTransactionView) {
                    EditTransactionView(
                        viewModel: EditTransactionViewModel(fireStoreTransactionManager: FireStoreTransactionManager(), userDefaultsManager: UserDefaultsManager(), transaction: transactionData.unResolvedTransactions[self.selectedEditTransaction.index]),
                        isEditTransactionView: $isEditTransactionView
                    )
                    .presentationDetents([.large])
                } // sheetここまで

            }
            .padding()
        }
    }

    /**
     greetingTextを表示するView
     - Description
     - 6-11時は「おはよう」
     - 11-18時は「こんにちは」
     - 18時-6時は「こんばんは」
     */
    private func greetingTextView() -> some View {
        return HStack {
            Text(greetingText)
                .foregroundColor(Color.black)
                .font(.title2)
        }
        .onAppear {
            self.createGreetingText()
        }
    }

    /**
     精算ボタンのView
     - Description
     - 精算ボタンを押すと、まずアラートを表示させる
     */
    private func resolveTransactionButton() -> some View {
        Button(action: {
            self.isAllResolveAlert = true
        }, label: {
            HStack(spacing: 3) {
                Image(systemName: imageNameProperty.checkmarkCircleSystemImage)
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
        .alert("精算", isPresented: $isAllResolveAlert){
            Button("キャンセル"){
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

    /**
     未精算リストのView
     */
    private func unResolvedListView() -> some View {
        ForEach(0 ..< transactionData.unResolvedTransactions.count,  id: \.self) { index in
            HStack {
                // もし自分が立替者だったら、自分のアイコンを表示
                // もしパートナーが立替者だったら、パートナーのアイコンを表示
                if transactionData.unResolvedTransactions[index].debtorId == myUserId {

                    Image(uiImage: UIImage(data: myIconData) ?? UIImage(named: imageNameProperty.iconNotFound)!)
                        .resizable()
                        .scaledToFill()
                        .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28, alignment: .center)
                        .clipShape(Circle())
                } else {
                    Image(uiImage: UIImage(data: partnerIconData) ?? UIImage(named: imageNameProperty.iconNotFound)!)
                        .resizable()
                        .scaledToFill()
                        .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28, alignment: .center)
                        .clipShape(Circle())
                }

                // アイコンの隣に登録した日時とタイトルを表示
                VStack(alignment: .leading) {
                    Text(self.dateToString(date: transactionData.unResolvedTransactions[index].createdAt))
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    Text(transactionData.unResolvedTransactions[index].title)
                }
                Spacer()

                // リストの一番右側に金額を表示
                VStack(alignment: .trailing) {
                    Text("¥\(transactionData.unResolvedTransactions[index].amount)")
                }
            }
            .padding(3)
            .foregroundColor(.black)
            .contentShape(Rectangle())
            .onTapGesture {
                self.selectedTransactionIndex = index
                self.isTransactionDescriptionAlert = true
            }
            .contextMenu {
                Button() {
                    self.selectedResolveTransactionIndex = index
                    self.isOnlyResolveAlert = true
                } label: {
                    Label("精算", systemImage: imageNameProperty.checkmarkCircleSystemImage)
                }
                Button() {
                    self.selectedEditTransaction.index = index
                    self.isEditTransactionView = true
                } label: {
                    Label("編集", systemImage: imageNameProperty.pencilSystemImage)
                }
                Button() {
                    self.selectedDeleteTransactionIndex = index
                    self.isDeleteTransactionAlert = true
                } label: {
                    Label("削除", systemImage: imageNameProperty.trashFillSystemImage)
                }
            }
            // セルをタップで、詳細アラートを表示
            .alert("\(transactionData.unResolvedTransactions[self.selectedTransactionIndex].title)", isPresented: $isTransactionDescriptionAlert){
                Button("OK") {
                }
            } message: {
                let amount = transactionData.unResolvedTransactions[self.selectedTransactionIndex].amount
                let description = transactionData.unResolvedTransactions[self.selectedTransactionIndex].description
                let createdAt = self.dateToDetailString(date: transactionData.unResolvedTransactions[self.selectedTransactionIndex].createdAt)
                let debtor = transactionData.unResolvedTransactions[self.selectedTransactionIndex].debtorId == myUserId ? myUserName : partnerModifiedName

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
            .alert("注意", isPresented: $isDeleteTransactionAlert){
                Button("キャンセル") {
                }
                Button("OK") {
                    self.deleteTransaction(transactionId: transactionData.unResolvedTransactions[self.selectedDeleteTransactionIndex].id)
                }
            } message: {
                Text("「\(transactionData.unResolvedTransactions[self.selectedDeleteTransactionIndex].title)」を本当に削除してもよろしいですか？")
            } // alertここまで
            .alert("精算", isPresented: $isOnlyResolveAlert){
                Button("キャンセル") {
                }
                Button("OK") {
                    self.updateResolvedTransaction(transactionId: transactionData.unResolvedTransactions[self.selectedResolveTransactionIndex].id)
                }
            } message: {
                Text("「\(transactionData.unResolvedTransactions[self.selectedResolveTransactionIndex].title)」を精算してよろしいですか？")
            } // alertここまで
            .swipeActions(edge: .trailing, allowsFullSwipe: false)  {
                Button(role: .none) {
                    self.selectedDeleteTransactionIndex = index
                    self.isDeleteTransactionAlert = true
                } label: {
                    Image(systemName: imageNameProperty.trashFillSystemImage)
                }
                .tint(.red)

                Button(role: .none) {
                    self.selectedEditTransaction.index = index
                    self.isEditTransactionView = true
                } label: {
                    Image(systemName: imageNameProperty.pencilSystemImage)
                }
                .tint(.orange)

                Button(role: .none) {
                    self.selectedResolveTransactionIndex = index
                    self.isOnlyResolveAlert = true
                } label: {
                    Image(systemName: imageNameProperty.checkmarkCircleSystemImage)
                }
                .tint(.green)
            }

        }
    }

    /**
     リストが空の際に表示する画像と文言
     */
    private func unResolvedListIsNullView() -> some View {
        VStack {
            Image(imageNameProperty.sittingCatDark)
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

    // MARK: - Logics

    /**
     未精算のトランザクションを精算する
     */
    private func pushResolvedTransaction() {
        Task{
            do {
                isPKHUDProgress = true
                let ids = transactionData.unResolvedTransactions.map { $0.id }
                try await viewModel.updateResolvedTransactions(transactionIds: ids)
                isPKHUDProgress = false
                isPKHUDSuccess = true
            } catch {
                print(#function, error)
                isPKHUDProgress = false
                isPKHUDError = true
            }
        }
    }

    /**
     指定したトランザクションの削除
     - parameter transactionId: 削除するトランザクションのID
     */
    private func deleteTransaction(transactionId: String) {
        Task{
            do {
                isPKHUDProgress = true
                // ここでindexを0にしないと、out of range になる
                self.selectedDeleteTransactionIndex = 0
                self.selectedTransactionIndex = 0
                try await viewModel.deleteTransaction(transactionId: transactionId)
                isPKHUDProgress = false
                isPKHUDSuccess = true
            } catch {
                print(#function, error)
                isPKHUDProgress = false
                isPKHUDError = true
            }
        }
    }

    /**
     指定したトランザクションの精算
     - parameter transactionId: 精算するトランザクションのID
     */
    private func updateResolvedTransaction(transactionId: String) {
        Task{
            do {
                isPKHUDProgress = true
                // ここでindexを0にしないと、out of range になる
                self.selectedResolveTransactionIndex = 0
                self.selectedTransactionIndex = 0
                try await viewModel.updateResolvedTransaction(transactionId: transactionId)
                isPKHUDProgress = false
                isPKHUDSuccess = true
            } catch {
                print(#function, error)
                isPKHUDProgress = false
                isPKHUDError = true
            }
        }
    }

    /**
     時間によって挨拶を生成し、@State変数に代入する
     - Description
     - 6-11時は「おはよう」
     - 11-18時は「こんにちは」
     - 18時-6時は「こんばんは」
     */
    private func createGreetingText() {
        let dateFormatterForHour = DateFormatter()
        dateFormatterForHour.dateFormat = "HH"
        let currentHour = Int(dateFormatterForHour.string(from: Date())) ?? 0

        if currentHour >= 6 && currentHour < 11 {
            greetingText = "おはよう"
        } else if currentHour >= 11 && currentHour < 18 {
            greetingText = "こんにちは"
        } else {
            greetingText = "こんばんは"
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

struct CommonWalletTabView_Previews: PreviewProvider {
    static var previews: some View {
        CommonWalletView(viewModel: CommonWalletViewModel(fireStoreTransactionManager: FireStoreTransactionManager(), fireStoreUserManager: FireStoreUserManager()))
    }
}
