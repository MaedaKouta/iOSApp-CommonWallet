//
//  ChangePartnerNameView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import SwiftUI

struct ChangePartnerNameView: View {

    @Binding var isShowSettingView: Bool
    @ObservedObject var changePartnerNameViewModel = ChangePartnerNameViewModel()
    @State private var partnerName: String = ""
    @State private var isInputPartnerName: Bool = false

    var body: some View {

        VStack {
            TextField(changePartnerNameViewModel.beforePartnerName, text: $partnerName)
                .onChange(of: partnerName, perform: { newValue in
                    if partnerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        isInputPartnerName = false
                    } else {
                        isInputPartnerName = true
                    }
                })
                .onAppear{
                    partnerName = changePartnerNameViewModel.beforePartnerName
                }
                .textFieldStyle(.roundedBorder)
                .padding()

            Button(action: {
                let newPartnerName = partnerName.trimmingCharacters(in: .whitespacesAndNewlines)
                changePartnerNameViewModel.changePartnerName(newName: newPartnerName)
            }) {
                Text("設定する")
            }
            .disabled(!isInputPartnerName)

        }
        .toolbar {
            /// ナビゲーションバー左
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {isShowSettingView = false}) {
                    Text("完了")
                }
            }
        }

    }
}

//struct ChangePartnerNameView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangePartnerNameView()
//    }
//}
