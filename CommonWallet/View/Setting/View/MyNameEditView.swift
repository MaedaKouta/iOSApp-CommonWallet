//
//  MyNameEditView.swift
//  CommonWallet
//

import Foundation
import SwiftUI

struct MyNameEditView: View {

    // presentationMode.wrappedValue.dismiss() で画面戻れる
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: MyNameEditViewModel

    @State private var newName: String = ""
    @State private var isEnableComplete: Bool = false
    // キーボード
    @FocusState private var isKeyboardActive: Bool
    // Userdefaults
    @AppStorage(UserDefaultsKey().userName) private var myUserName = String()
    // PKHUD
    @State private var isPKHUDSuccess = false
    @State private var isPKHUDError = false
    @State private var isPKHUDProgress = false

    var body: some View {

        VStack {
            List {
                editMyUserNameSection()
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
                        isKeyboardActive = false  //  フォーカスを外す
                        await updateName(newName: self.newName)
                    }
                }) {
                    Text("完了")
                }
                .disabled(!isEnableComplete)
            }

            // キーボードのツールバー
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()         // 右寄せにする
                Button("閉じる") {
                    isKeyboardActive = false  //  フォーカスを外す
                }
            }

        }
    }


    // MARK: - Sections
    /**
     自身のUserNameを変更するSection.
     現在のUserNameと被っていない場合のみ, isEnableCompleteをtrueにする.
     - Returns: View(Section)
     */
    private func editMyUserNameSection() -> some View {
        Section {
            HStack {
                Text("名前")

                TextField(myUserName, text: $newName)
                    .focused(self.$isKeyboardActive)
                    .onChange(of: newName, perform: { newValue in
                        if newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            isEnableComplete = false
                        } else if myUserName == newValue {
                            isEnableComplete = false
                        } else {
                            isEnableComplete = true
                        }
                    })
                    .onAppear {
                        newName = myUserName
                    }
            }
        }
    }


    // MARK: - Logics
    /**
     自身のUserNameを更新する.
     処理中はインジケータを出す.  失敗時エラー表示, 成功時は成功表示後元の画面へ戻る.
     - Returns: View(Section)
     */
    private func updateName(newName: String) async {
        isPKHUDProgress = true
        let isSuccess = await viewModel.changeMyName(newName: newName)
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
        MyNameEditView(viewModel: MyNameEditViewModel(userDefaultsManager: UserDefaultsManager(), fireStoreUserManager: FireStoreUserManager()))
    }
}

