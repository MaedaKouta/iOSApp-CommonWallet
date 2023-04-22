//
//  AddPaymentView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct AddTransactionView: View {

    @ObservedObject var addTransactionViewModel: AddTransactionViewModel
    @Binding var isAddTransactionView: Bool

    @State private var selectedIndex = 0
    @State var title: String = ""
    @State var description: String = ""
    @State var amount: String = ""

    @State private var transactionResult: Result<Void, Error>? = nil
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {

        VStack {
            Text("支払った人")
            Picker("", selection: self.$selectedIndex) {
                Text(addTransactionViewModel.myName)
                    .tag(0)
                Text(addTransactionViewModel.partnerName)
                    .tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            TextField("タイトル", text: $title)
                .padding()
            TextField("メモ", text: $description)
                .padding()
            TextField("支払い金額を入力", text: $amount)
                .padding()

            Button ( action: {
                addTransaction(
                    creditorId: selectedIndex == 0 ? addTransactionViewModel.myUserId : addTransactionViewModel.partnerUserId,
                    debtorId: selectedIndex == 0 ? addTransactionViewModel.partnerUserId : addTransactionViewModel.myUserId,
                    title: title,
                    description: description,
                    amount: Int(amount) ?? 0)
            }) {
                Text("登録")
            }

        }
        .padding()

        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Transaction Result"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        })

    }

    func addTransaction(creditorId: String, debtorId: String, title: String, description: String, amount: Int) {
        Task{

            let result = try await addTransactionViewModel.addTransaction(creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount)

            switch result {
            case .success:
                // 成功した場合の処理
                print("Transactionの登録成功")
                self.transactionResult = .success(())
                self.alertMessage = "Transaction succeeded!"
                self.isAddTransactionView = false
                self.showAlert = true
                break
            case .failure(let error):
                // 失敗した場合の処理
                print("Transactionの登録失敗")
                self.transactionResult = .failure(error)
                self.alertMessage = "Transaction failed with error: \(error.localizedDescription)"
                self.showAlert = true
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
