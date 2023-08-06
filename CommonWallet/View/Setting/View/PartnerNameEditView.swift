//
//  ChangePartnerNameView.swift
//  CommonWallet
//

import SwiftUI

struct PartnerNameEditView: View {

    // presentationMode.wrappedValue.dismiss() で画面戻れる
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: PartnerNameEditViewModel

    @State private var afterPartnerName: String = ""
    // キーボード
    @FocusState private var isKeyboardActive: Bool
    // Userdefaults
    @AppStorage(UserDefaultsKey().partnerName) private var partnerName = String()
    // Alert
    @State private var isEnableComplete: Bool = false
    // PKHUD
    @State private var isPKHUDSuccess = false
    @State private var isPKHUDError = false
    @State private var isPKHUDProgress = false

    var body: some View {

        VStack {
            List {
                editPartnerNameSection()
            }
        }
        .navigationTitle("パートナーの表示名")
        .PKHUD(isPresented: $isPKHUDSuccess, HUDContent: .success, delay: 1.0)
        .PKHUD(isPresented: $isPKHUDProgress, HUDContent: .progress, delay: 1.0)
        .PKHUD(isPresented: $isPKHUDError, HUDContent: .error, delay: 1.0)
        .toolbar {
            /// ナビゲーションバー右
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        isKeyboardActive = false  //  フォーカスを外す
                        let fixedAfterPartnerName = afterPartnerName.trimmingCharacters(in: .whitespacesAndNewlines)
                        await updatePartnerName(newName: fixedAfterPartnerName)
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

    /**
     パートナーのニックネームを変更するSection.
     現在のニックネームと重複していない場合のみ, isEnableCompleteをtrueにする.
     - Returns: View(Section)
     */
    private func editPartnerNameSection() -> some View {
        Section {
            HStack {
                Text("表示名")
                TextField(partnerName, text: $afterPartnerName)
                    .focused(self.$isKeyboardActive)
                    .onChange(of: afterPartnerName, perform: { newValue in
                        if afterPartnerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            isEnableComplete = false
                        } else if partnerName == newValue {
                            isEnableComplete = false
                        } else {
                            isEnableComplete = true
                        }
                    })
                    .onAppear {
                        afterPartnerName = partnerName
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
    private func updatePartnerName(newName: String) async {
        isPKHUDProgress = true
        let isSuccess = await viewModel.changePartnerName(newName: newName)
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

struct ChangePartnerNameView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerNameEditView(viewModel: PartnerNameEditViewModel(userDefaultsManager: UserDefaultsManager(), fireStorePartnerManager: FireStorePartnerManager()))
    }
}
