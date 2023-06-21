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

    @StateObject var viewModel: ConnectPartnerViewModel

    @State private var inputNumber: String = ""
    @State private var isEnableComplete = false

    // PKHUD
    @State private var isPKHUDProgress = false
    @State private var isPKHUDSuccess = false
    @State private var isPKHUDError = false

    private let numberLimit = 12

    var body: some View {
        VStack {
            List {
                inputPartnerNumberSection()
            }
        }
        .PKHUD(isPresented: $isPKHUDProgress, HUDContent: .progress, delay: .infinity)
        .PKHUD(isPresented: $isPKHUDSuccess, HUDContent: .success, delay: 1.0)
        .PKHUD(isPresented: $isPKHUDError, HUDContent: .error, delay: 1.0)
        .toolbar {
            // ナビゲーションバー右
            ToolbarItem(placement: .navigationBarTrailing) {
                // After tapping: 通信してパートナー連携後, 画面を戻る
                Button(action: {
                    Task {
                        await addPartner(shareNumber: inputNumber)
                    }
                }) {
                    Text("完了")
                }
                .disabled(!isEnableComplete)
            }
        }
    }

    // MARK: - Section
    /**
     パートナーのニックネームを記述するSection.
     12桁の入力があった場合のみ, isEnableCompleteをtrueにする.
     - Returns: View(Section)
     */
    private func inputPartnerNumberSection() -> some View {
        Section {
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
        } footer: {
            Text("連携番号は、パートナーの設定画面から確認できる12桁の番号です。")
        }
    }

    // MARK: - Logics
    /**
     パートナーを登録する
     処理中はインジケータを出す.  失敗時エラー表示, 成功時は成功表示後元の画面へ戻る.
     - parameter shareNumber: パートナーの共有番号
     */
    private func addPartner(shareNumber: String) async {
        do {
            isPKHUDProgress = true
            try await viewModel.connectPartner(partnerShareNumber: inputNumber)
            isPKHUDProgress = false
            isPKHUDSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                presentationMode.wrappedValue.dismiss()
            }
        } catch {
            print(error)
            isPKHUDProgress = false
            isPKHUDError = true
        }
    }

}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectPartnerView(viewModel: ConnectPartnerViewModel(fireStorePartnerManager: FireStorePartnerManager(), userDefaultsManager: UserDefaultsManager()))
    }
}
