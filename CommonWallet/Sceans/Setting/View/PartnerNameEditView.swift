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

    // Userdefaults
    @AppStorage(UserDefaultsKey().partnerModifiedName) private var partnerModifiedName = String()
    // Alert
    @State private var isEnableComplete: Bool = false
    // PKHUD
    @State private var isPKHUDSuccess = false

    var body: some View {

        VStack {
            List {
                editPartnerNameSection()
            }
        }
        .navigationTitle("パートナーのニックネーム")
        .PKHUD(isPresented: $isPKHUDSuccess, HUDContent: .success, delay: 1.0)
        .toolbar {
            /// ナビゲーションバー右
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    let fixedAfterPartnerName = afterPartnerName.trimmingCharacters(in: .whitespacesAndNewlines)
                    partnerModifiedName = fixedAfterPartnerName
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

    /**
     パートナーのニックネームを変更するSection.
     現在のニックネームと重複していない場合のみ, isEnableCompleteをtrueにする.
     - Returns: View(Section)
     */
    private func editPartnerNameSection() -> some View {
        Section {
            HStack {
                Text("名前")
                TextField(partnerModifiedName, text: $afterPartnerName)
                    .onChange(of: afterPartnerName, perform: { newValue in
                        if afterPartnerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            isEnableComplete = false
                        } else if partnerModifiedName == newValue {
                            isEnableComplete = false
                        } else {
                            isEnableComplete = true
                        }
                    })
                    .onAppear{
                        afterPartnerName = partnerModifiedName
                    }
            }
        }
    }
}

struct ChangePartnerNameView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerNameEditView(viewModel: PartnerNameEditViewModel())
    }
}
