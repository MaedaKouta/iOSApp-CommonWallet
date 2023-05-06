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
    @State var title: String = ""
    @State var description: String = ""
    @State var amount: String = ""

    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {

        VStack {
            Text("支払った人")
            Picker("", selection: $editTransactionViewModel.selectedIndex) {
                Text(editTransactionViewModel.myName)
                    .tag(0)
                Text(editTransactionViewModel.partnerName)
                    .tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            TextField("タイトル", text: $editTransactionViewModel.transaction.title)
                .padding()
            TextField("メモ", text: $editTransactionViewModel.transaction.description)
                .padding()
            TextField("支払い金額を入力", value: $editTransactionViewModel.transaction.amount, format: .number)
                .padding()

            Button ( action: {
                if editTransactionViewModel.selectedIndex == 0 {
                    editTransactionViewModel.transaction.debtorId = editTransactionViewModel.myUserId
                } else {
                    editTransactionViewModel.transaction.debtorId = editTransactionViewModel.partnerUserId
                }
                // 通信
                updateTransaction()
            }) {
                Text("上書き")
            }

        }
        .padding()

        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Transaction Result"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        })

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
