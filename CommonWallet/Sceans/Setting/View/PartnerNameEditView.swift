//
//  ChangePartnerNameView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import SwiftUI

struct PartnerNameEditView: View {

    @ObservedObject var changePartnerNameViewModel: PartnerNameEditViewModel

    @Binding var isChangePartnerNameView: Bool

    @State private var partnerName: String = ""
    @State private var isEnableComplete: Bool = false

    @State private var text = ""

    var body: some View {

        VStack {
            List {
                Section {
                    HStack {
                        Text("名前")
                        TextField(changePartnerNameViewModel.beforePartnerName, text: $partnerName)
                            .onChange(of: partnerName, perform: { newValue in
                                if partnerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    isEnableComplete = false
                                } else if changePartnerNameViewModel.beforePartnerName == newValue {
                                    isEnableComplete = false
                                } else {
                                    isEnableComplete = true
                                }


                            })
                            .onAppear{
                                partnerName = changePartnerNameViewModel.beforePartnerName
                            }
                    }
                }
            }
        }
        .navigationTitle("パートナーのニックネーム")
        .toolbar {
            /// ナビゲーションバー右
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    let newPartnerName = partnerName.trimmingCharacters(in: .whitespacesAndNewlines)
                    changePartnerNameViewModel.changePartnerName(newName: newPartnerName)
                    isChangePartnerNameView = false
                }) {
                    Text("完了")
                }
                .disabled(!isEnableComplete)
            }
        }
    }
}

struct ChangePartnerNameView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerNameEditView(changePartnerNameViewModel: PartnerNameEditViewModel(), isChangePartnerNameView: .constant(false))
    }
}
