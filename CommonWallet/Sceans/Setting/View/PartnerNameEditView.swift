//
//  ChangePartnerNameView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import SwiftUI

struct PartnerNameEditView: View {

    // presentationMode.wrappedValue.dismiss() で画面戻れる
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: PartnerNameEditViewModel

    @State private var afterPartnerName: String = ""
    @State private var isEnableComplete: Bool = false

    @State private var isPKHUDSuccess = false

    var body: some View {

        VStack {
            List {
                Section {
                    editPartnerNameView()
                }
            }
        }
        .navigationTitle("パートナーのニックネーム")
        .PKHUD(isPresented: $isPKHUDSuccess, HUDContent: .success, delay: 1.0)
        .toolbar {
            /// ナビゲーションバー右
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    let fixedAfterPartnerName = afterPartnerName.trimmingCharacters(in: .whitespacesAndNewlines)
                    viewModel.changePartnerName(newName: fixedAfterPartnerName)
                    isPKHUDSuccess = true
                    // PKHUD Suceesのアニメーションが1秒経過してから元の画面に戻る
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("完了")
                }
                .disabled(!isEnableComplete)
            }
        }

    }

    private func editPartnerNameView() -> some View {
        HStack {
            Text("名前")

            TextField(viewModel.beforePartnerName, text: $afterPartnerName)
                .onChange(of: afterPartnerName, perform: { newValue in
                    if afterPartnerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        isEnableComplete = false
                    } else if viewModel.beforePartnerName == newValue {
                        isEnableComplete = false
                    } else {
                        isEnableComplete = true
                    }
                })
                .onAppear{
                    afterPartnerName = viewModel.beforePartnerName
                }
        }
    }
}

struct ChangePartnerNameView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerNameEditView(viewModel: PartnerNameEditViewModel())
    }
}
