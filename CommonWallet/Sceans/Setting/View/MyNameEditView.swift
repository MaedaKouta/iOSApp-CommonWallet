//
//  MyNameEditView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/06/06.
//

import Foundation
import SwiftUI

struct MyNameEditView: View {

    // presentationMode.wrappedValue.dismiss() で画面戻れる
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: MyNameEditViewModel
    @State private var afterName: String = ""
    @State private var isEnableComplete: Bool = false

    @State private var isPKHUDSuccess = false
    @State private var isPKHUDError = false
    @State private var isPKHUDProgress = false


    var body: some View {

        VStack {
            List {
                Section {
                    editPartnerNameView()
                }
            }
        }
        .navigationTitle("名前")
        .PKHUD(isPresented: $isPKHUDSuccess, HUDContent: .success, delay: 1.0)
        .PKHUD(isPresented: $isPKHUDError, HUDContent: .error, delay: 1.0)
        .PKHUD(isPresented: $isPKHUDProgress, HUDContent: .progress, delay: .infinity)
        .toolbar {
            /// ナビゲーションバー右
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    Task {
                        let fixedAfterPartnerName = afterName.trimmingCharacters(in: .whitespacesAndNewlines)
                        await updateName()
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

            TextField(viewModel.beforeMyName, text: $afterName)
                .onChange(of: afterName, perform: { newValue in
                    if afterName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        isEnableComplete = false
                    } else if viewModel.beforeMyName == newValue {
                        isEnableComplete = false
                    } else {
                        isEnableComplete = true
                    }
                })
                .onAppear{
                    afterName = viewModel.beforeMyName
                }
        }
    }

    func updateName() async {
        isPKHUDProgress = true
        let isSuccess = await viewModel.changeMyName(newName: self.afterName)
        if isSuccess {
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
}

struct MyNameEditView_Previews: PreviewProvider {
    static var previews: some View {
        MyNameEditView(viewModel: MyNameEditViewModel())
    }
}

