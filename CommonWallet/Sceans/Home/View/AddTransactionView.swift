//
//  AddPaymentView.swift
//  CommonWallet
//

import SwiftUI
import PKHUD

struct AddTransactionView: View {

    @ObservedObject var addTransactionViewModel: AddTransactionViewModel
    @ObservedObject var commonWalletViewModel: CommonWalletViewModel
    @Binding var isAddTransactionView: Bool

    @State private var selectedIndex = 0
    @State var title: String = ""
    @State var description: String = ""
    @State var amount: Int?
    @State private var isEnableComplete: Bool = false
    // キーボード
    @FocusState private var isKeyboardActive: Bool
    // PKHUD
    @State private var isPKHUDProgress = false
    @State private var isPKHUDSuccess = false
    @State private var isPKHUDError = false
    // UserDefaults
    @AppStorage(UserDefaultsKey().userId) private var myUserId = String()
    @AppStorage(UserDefaultsKey().userName) private var myUserName = String()
    @AppStorage(UserDefaultsKey().shareNumber) private var myShareNumber = String()
    @AppStorage(UserDefaultsKey().partnerUserId) private var partnerUserId = String()
    @AppStorage(UserDefaultsKey().partnerName) private var partnerName = String()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {

                    creditorInputView()
                        .padding()

                    titleInputView()
                        .padding()

                    amountInputView()
                        .padding()

                    descriptionInputView()
                        .padding()
                }
                .padding()
                .navigationTitle("追加")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // ナビゲーションバー左
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {isAddTransactionView = false}) {
                            Text("キャンセル")
                        }
                    }
                    // ナビゲーションバー右
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {
                            isKeyboardActive = false  //  フォーカスを外す
                            let submitTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                            let submitDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
                            addTransaction(
                                creditorId: selectedIndex == 0 ? myUserId : partnerUserId,
                                debtorId: selectedIndex == 0 ? partnerUserId : myUserId,
                                title: submitTitle,
                                description: submitDescription,
                                amount: amount ?? 0)
                        }) {
                            Text("完了")
                        }
                        .disabled(!isEnableComplete)
                    }

                    // キーボードのツールバー
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()         // 右寄せにする
                        Button("閉じる") {
                            isKeyboardActive = false  //  フォーカスを外す
                        }
                    }
                }
            } // ScrollViewここまで
        } // NavigationViewここまで
        .PKHUD(isPresented: $isPKHUDProgress, HUDContent: .progress, delay: .infinity)
        .PKHUD(isPresented: $isPKHUDSuccess, HUDContent: .success, delay: 0.7)
        .PKHUD(isPresented: $isPKHUDError, HUDContent: .labeledError(title: nil, subtitle: "エラー"), delay: 0.7)
    }


    // MARK: - Views
    private func creditorInputView() -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("立て替え者")
            Picker("", selection: $selectedIndex) {
                Text(myUserName)
                    .tag(0)
                Text(partnerName)
                    .tag(1)
            }
            .padding(.horizontal)
            .pickerStyle(SegmentedPickerStyle())
        }
    }

    // タイトル
    private func titleInputView() -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("タイトル")
            TextField("駅前の薬局", text: $title)
                .focused(self.$isKeyboardActive)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .focused($isKeyboardActive)
                .onChange(of: title, perform: { newValue in
                    self.checkEnableComplete()
                })
        }
    }

    // 詳細
    private func amountInputView() -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("金額")
            TextField("480円", value: $amount, format: .number)
                .focused(self.$isKeyboardActive)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .focused($isKeyboardActive)
                .onChange(of: amount, perform: { newValue in
                    self.checkEnableComplete()
                })
        }
    }

    // 詳細
    private func descriptionInputView() -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("詳細")
                .foregroundColor(.gray)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $description)
                    .frame(height: 100)
                    .focused($isKeyboardActive)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(uiColor: .systemGray5), lineWidth: 1))
                if description.isEmpty {
                    Text("帰宅時にあわてて購入した洗剤")
                        .foregroundColor(Color(uiColor: .placeholderText))
                        .allowsHitTesting(false)
                        .padding(5)
                }
            }.padding(.horizontal)
        }
    }


    // MARK: -Logics
    private func checkEnableComplete() {
        let submitTitle = title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let submitAmount = amount

        if (submitTitle.description.isEmpty == true || submitAmount == nil) {
            isEnableComplete = false
        } else {
            isEnableComplete = true
        }
    }

    private func addTransaction(creditorId: String?, debtorId: String?, title: String, description: String, amount: Int) {
        Task{
            isPKHUDProgress = true
            let result = try await addTransactionViewModel.addTransaction(myShareNumber: myShareNumber, creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount)

            switch result {
            case .success:
                isPKHUDProgress = false
                isPKHUDSuccess = true
                self.isAddTransactionView = false
                break
            case .failure(let error):
                print(#function, error)
                isPKHUDProgress = false
                isPKHUDError = true
                break
            }
        }
    }

}

//struct AddPaymentView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPaymentView(isAddPaymentView: Binding<true>)
//    }
//}
