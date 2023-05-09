//
//  EditTransactionView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/05/06.
//

import SwiftUI

struct EditTransactionView: View {

    @ObservedObject var editTransactionViewModel: EditTransactionViewModel
    @ObservedObject var commonWalletViewModel: CommonWalletViewModel
    @Binding var isEditTransactionView: Bool

    @State private var selectedIndex = 0
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {

        NavigationView {
            ScrollView {
                VStack(spacing: 0) {

                    VStack(alignment: .leading, spacing: 3) {
                        Text("立て替え者")
                        Picker("", selection: $editTransactionViewModel.selectedIndex) {
                            Text(editTransactionViewModel.myName)
                                .tag(0)
                            Text(editTransactionViewModel.partnerName)
                                .tag(1)
                        }
                        .padding(.horizontal)
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding()


                    VStack(alignment: .leading, spacing: 3) {
                        Text("タイトル")
                        TextField(editTransactionViewModel.beforeTransaction.title, text: $editTransactionViewModel.transaction.title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    .padding()

                    VStack(alignment: .leading, spacing: 3) {
                        Text("詳細")
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $editTransactionViewModel.transaction.description)
                                .frame(height: 100)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(uiColor: .systemGray5), lineWidth: 1))
                            if editTransactionViewModel.transaction.description.isEmpty {
                                Text(editTransactionViewModel.beforeTransaction.description)
                                    .foregroundColor(Color(uiColor: .placeholderText))
                                    .allowsHitTesting(false)
                                    .padding(5)
                            }
                        }.padding(.horizontal)
                    }
                    .padding()

                    VStack(alignment: .leading, spacing: 3) {
                        Text("金額")
                        TextField("\(editTransactionViewModel.beforeTransaction.amount)", value: $editTransactionViewModel.transaction.amount, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    .padding()

                    Button ( action: {
                        if editTransactionViewModel.selectedIndex == 0 {
                            editTransactionViewModel.transaction.creditorId = editTransactionViewModel.myUserId
                            editTransactionViewModel.transaction.debtorId = editTransactionViewModel.partnerUserId
                        } else {
                            editTransactionViewModel.transaction.creditorId = editTransactionViewModel.partnerUserId
                            editTransactionViewModel.transaction.debtorId = editTransactionViewModel.myUserId
                        }
                        // 通信
                        updateTransaction()
                    }) {
                        HStack {
                            Text("上書き")
                        }
                        .frame(width: 100.0, height: 25.0)
                        .padding(10)
                        .accentColor(Color.black)
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: Color.gray, radius: 3, x: 0, y: 0)
                    }

                }
                .padding()
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Transaction Result"),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK")))
                })
                .navigationTitle("追加")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    /// ナビゲーションバー左
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {isEditTransactionView = false}) {
                            Text("キャンセル")
                        }
                    }
                }
            } // ScrollViewここまで
        } // NavigationViewここまで
    }

    func updateTransaction() {
        Task {
            let result = try await editTransactionViewModel.updateTransaction()

            switch result {
            case .success:
                // 成功した場合の処理
                print("Transactionの登録成功")
                //self.fetchTransactions()
                self.alertMessage = "Transaction succeeded!"
                self.isEditTransactionView = false
                self.showAlert = true
                break
            case .failure(let error):
                // 失敗した場合の処理
                print("Transactionの登録失敗")
                self.alertMessage = "Transaction failed with error: \(error.localizedDescription)"
                self.showAlert = true
                break
            }
        }
    }

    /// 遷移元のViewのTransaction情報を更新するために、遷移元のviewModelを操作
    private func fetchTransactions() {
        Task{
            try await commonWalletViewModel.fetchTransactions()
        }
    }

}
