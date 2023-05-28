//
//  ContentView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import SwiftUI
import Combine

struct ConnectPartnerView: View {

    @ObservedObject var viewModel: ConnectPartnerViewModel
    @Binding var isConnectPartnerView: Bool

    @State private var inputNumber: String = ""
    @State private var isEnableComplete = false

    private let numberLimit = 12

    var body: some View {
        VStack {
            List {
                Section {
                    inputPartnerNumberView()
                } footer: {
                    Text("連携番号は、パートナーの設定画面から確認できる12桁の番号です。")
                }
            }
        }
        .toolbar {
            /// ナビゲーションバー右
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    isConnectPartnerView = false
                    Task {
                        await viewModel.connectPartner(partnerShareNumber: inputNumber)
                    }
                }) {
                    Text("完了")
                }
                .disabled(!isEnableComplete)
            }
        }
    }

    private func inputPartnerNumberView() -> some View {
        HStack {
            Text("連携番号")
            Spacer()

            TextField("123456781234", text: $inputNumber)
                .keyboardType(.numberPad)
                .padding(.leading)
            // numberLimit(12文字)以上は入力できない
                .onReceive(Just(inputNumber), perform: { _ in
                    if inputNumber.count > numberLimit {
                        inputNumber = String(inputNumber.prefix(numberLimit))
                    }
                })
            // numberrLimit(12文字)入力があった際に完了ボタンを押せる
                .onChange(of: inputNumber, perform: { newValue in
                    if inputNumber.trimmingCharacters(in: .whitespacesAndNewlines).count == numberLimit {
                        isEnableComplete = true
                    } else {
                        isEnableComplete = false
                    }
                })
        }
    }

}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectPartnerView(viewModel: ConnectPartnerViewModel(), isConnectPartnerView: .constant(true))
    }
}
