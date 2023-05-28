//
//  ChangePartnerNameView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import SwiftUI

struct PartnerNameEditView: View {

    @ObservedObject var viewModel: PartnerNameEditViewModel

    @Binding var isPartnerNameEditView: Bool

    @State private var afterPartnerName: String = ""
    @State private var isEnableComplete: Bool = false

    var body: some View {

        VStack {
            List {
                Section {
                    editPartnerNameView()
                }
            }
        }
        .navigationTitle("パートナーのニックネーム")
        .toolbar {
            /// ナビゲーションバー右
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    let fixedAfterPartnerName = afterPartnerName.trimmingCharacters(in: .whitespacesAndNewlines)
                    viewModel.changePartnerName(newName: fixedAfterPartnerName)
                    isPartnerNameEditView = false
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
        PartnerNameEditView(viewModel: PartnerNameEditViewModel(), isPartnerNameEditView: .constant(false))
    }
}
