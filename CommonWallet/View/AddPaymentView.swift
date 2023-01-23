//
//  AddPaymentView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct AddPaymentView: View {

    @State private var selectedIndex = 0
    @State var purchase: String = ""
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

            TextField("購入したものを入力", text: $purchase)
                .padding()
            TextField("支払い金額を入力", text: $cost)
                .padding()

            Button ( action: {
                // 画面をもとに戻す
            }) {
                Text("登録")
            }

        }
        .padding()

    }
}

struct AddPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        AddPaymentView()
    }
}
