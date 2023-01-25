//
//  AddPaymentView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct AddPaymentView: View {

    @ObservedObject var addPaymentViewModel = AddPaymentViewModel()

    @Binding var isAddPaymentView: Bool

    @State private var selectedIndex = 0
    @State var title: String = ""
    @State var memo: String = ""
    @State var cost: String = ""

    var body: some View {

        VStack {
            Text("支払った人")
            Picker("", selection: self.$selectedIndex) {
                Text("かずき")
                    .tag(0)
                Text("さくら")
                    .tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            TextField("タイトル", text: $title)
                .padding()
            TextField("メモ", text: $memo)
                .padding()
            TextField("支払い金額を入力", text: $cost)
                .padding()

            Button ( action: {
                // 画面をもとに戻す
                // 後でViewmodelに書く
                Task {
                    await  addPaymentViewModel.createPayment(
                        title: title,
                        memo: memo,
                        cost: Int(cost) ?? 0,
                        isMyPayment: selectedIndex==0 ? true : false,
                        complition: { isSuccess, message in
                            if isSuccess {
                                print("登録成功")
                                isAddPaymentView = false
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
