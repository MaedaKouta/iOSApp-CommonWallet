//
//  EditTransactionView.swift
//  CommonWallet
//

import SwiftUI
import PKHUD

struct EditTransactionView: View {

    @ObservedObject var viewModel: EditTransactionViewModel
    @Binding var isEditTransactionView: Bool

    @State private var selectedIndex = 0
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
    @AppStorage(UserDefaultsKey().partnerUserId) private var partnerUserId = String()
    @AppStorage(UserDefaultsKey().partnerModifiedName) private var partnerModifiedName = String()

    var body: some View {

        NavigationView {
            ScrollView {
                VStack(spacing: 0) {

                    creditorInputView()
                        .padding()

                    titleInputView()
                        .padding()

                    descriptionInputView()
                        .padding()

                    amountInputView()
                        .padding()
                }
                .padding()
                .navigationTitle("上書き")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    /// ナビゲーションバー左
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {isEditTransactionView = false}) {
                            Text("キャンセル")
                        }
                    }

                    // ナビゲーションバー右
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {

                            updateTransaction()
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
        .PKHUD(isPresented: $isPKHUDSuccess, HUDContent: .labeledSuccess(title: nil, subtitle: "上書き完了"), delay: 0.75)
        .PKHUD(isPresented: $isPKHUDError, HUDContent: .labeledError(title: nil, subtitle: "予期せぬエラーが発生しました"), delay: 0.75)
    }


    // MARK: - Views
    private func creditorInputView() -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("立て替え者")
            Picker("", selection: $viewModel.selectedIndex) {
                Text(myUserName)
                    .tag(0)
                Text(partnerModifiedName)
                    .tag(1)
            }
            .padding(.horizontal)
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: viewModel.selectedIndex, perform: { newValue in
                if viewModel.selectedIndex == 0 {
                    viewModel.newTransaction.creditorId = myUserId
                    viewModel.newTransaction.debtorId = partnerUserId
                } else {
                    viewModel.newTransaction.creditorId = partnerUserId
                    viewModel.newTransaction.debtorId = myUserId
                }
                self.checkEnableComplete()
            })
        }
    }

    // タイトル
    private func titleInputView() -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("タイトル")
            TextField(viewModel.beforeTransaction.title, text: $viewModel.newTransaction.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onChange(of: viewModel.newTransaction.title, perform: { newValue in
                    self.checkEnableComplete()
                })
        }
    }

    // 詳細
    private func descriptionInputView() -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("詳細")
            ZStack(alignment: .topLeading) {
                TextEditor(text: $viewModel.newTransaction.description)
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(uiColor: .systemGray5), lineWidth: 1))
                    .onChange(of: viewModel.newTransaction.description, perform: { newValue in
                        self.checkEnableComplete()
                    })
                if viewModel.newTransaction.description.isEmpty {
                    Text(viewModel.beforeTransaction.description)
                        .foregroundColor(Color(uiColor: .placeholderText))
                        .allowsHitTesting(false)
                        .padding(5)
                }
            }.padding(.horizontal)
        }
    }

    // 詳細
    private func amountInputView() -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("金額")
            TextField("\(viewModel.beforeTransaction.amount)", value: $viewModel.newTransaction.amount, format: .number)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onChange(of: viewModel.newTransaction.amount, perform: { newValue in
                    self.checkEnableComplete()
                })
        }
    }

    // MARK: -Logics
    private func checkEnableComplete() {
        let submitCreditorId = viewModel.newTransaction.creditorId
        let submitTitle = viewModel.newTransaction.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let submitDescription = viewModel.newTransaction.description.trimmingCharacters(in: .whitespacesAndNewlines)
        let submitAmount = viewModel.newTransaction.amount

        // タイトルと金額が空ではない&&タイトルと金額と詳細のいずれかが前の値と違う
        if (submitTitle.description.isEmpty != true && submitAmount.description.isEmpty != true) {
            if (submitCreditorId != viewModel.beforeTransaction.creditorId ||
                submitTitle != viewModel.beforeTransaction.title ||
                submitDescription != viewModel.beforeTransaction.description ||
                submitAmount != viewModel.beforeTransaction.amount) {
                isEnableComplete = true
            } else {
                isEnableComplete = false
            }
        } else {
            isEnableComplete = false
        }
    }

    func updateTransaction() {
        Task {
            isPKHUDProgress = true
            let result = try await viewModel.updateTransaction()

            switch result {
            case .success:
                isPKHUDProgress = false
                isPKHUDSuccess = true
                self.isEditTransactionView = false
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
