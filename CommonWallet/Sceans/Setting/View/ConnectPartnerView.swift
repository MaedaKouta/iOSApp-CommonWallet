//
//  ContentView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import SwiftUI
import Combine

struct ConnectPartnerView: View {

    // presentationMode.wrappedValue.dismiss() で画面戻れる
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel: ConnectPartnerViewModel

    @State private var inputNumber: String = ""
    @State private var isEnableComplete = false

    @State private var isPKHUDProgress = false
    @State private var isPKHUDSuccess = false
    @State private var isPKHUDError = false

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
        .PKHUD(isPresented: $isPKHUDProgress, HUDContent: .progress, delay: .infinity)
        .PKHUD(isPresented: $isPKHUDSuccess, HUDContent: .success, delay: 1.0)
        .PKHUD(isPresented: $isPKHUDError, HUDContent: .error, delay: 1.0)
        .toolbar {
            /// ナビゲーションバー右
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    isPKHUDProgress = true
                    Task {
                        let result = await viewModel.connectPartner(partnerShareNumber: inputNumber)
                        if result {
                            isPKHUDProgress = false
                            isPKHUDSuccess = true
                            // PKHUD Suceesのアニメーションが1秒経過してから元の画面に戻る
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        } else {
                            isPKHUDProgress = false
                            isPKHUDError = true
                        }
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
        ConnectPartnerView(viewModel: ConnectPartnerViewModel())
    }
}
