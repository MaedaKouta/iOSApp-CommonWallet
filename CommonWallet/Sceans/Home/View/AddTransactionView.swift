//
//  AddPaymentView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct AddTransactionView: View {

    @ObservedObject var addTransactionViewModel = AddTransactionViewModel()
    @Binding var isAddTransactionView: Bool

    @State private var selectedIndex = 0
    @State var title: String = ""
    @State var description: String = ""
    @State var amount: String = ""

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
                // 画面をもとに戻す
                // 後でViewmodelに書く
                Task {

                    await  addTransactionViewModel.addTransaction(
                        creditorId: selectedIndex == 0 ? addTransactionViewModel.myUserId : addTransactionViewModel.partnerUserId,
                        debtorId: selectedIndex == 0 ? addTransactionViewModel.partnerUserId : addTransactionViewModel.myUserId,
                        title: title,
                        description: description,
                        amount: Int(amount) ?? 0,
                        complition: { isSuccess, message in
                            if isSuccess {
                                print("登録成功"+message)
                                isAddTransactionView = false
                            } else {
                                print("登録失敗", message)
                            }
                        })
                }
            }) {
                Text("登録")
            }

        }
        .padding()

    }
}

//struct AddPaymentView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPaymentView(isAddPaymentView: Binding<true>)
//    }
//}
