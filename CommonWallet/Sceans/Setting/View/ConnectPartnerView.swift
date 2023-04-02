//
//  ContentView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import SwiftUI

struct ConnectPartnerView: View {

    @ObservedObject var connectPartnerViewModel = ConnectPartnerViewModel()

    @Binding var isShowSettingView: Bool

    @State private var firstBreakText: String = ""
    @State private var secondBreakText: String = ""
    @State private var thirdBreakText: String = ""

    @State private var isInputtedFirstBreakText: Bool = false
    @State private var isInputtedSecondBreakText: Bool = false
    @State private var isInputtedThirdBreakText: Bool = false

    var body: some View {
        VStack {

            HStack {
                TextField("1234", text: $firstBreakText)
                    .onChange(of: firstBreakText, perform: { newValue in
                        if(firstBreakText.count == 4) {
                            isInputtedFirstBreakText = true
                        } else {
                            isInputtedFirstBreakText = false
                        }
                    })
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                TextField("1234", text: $secondBreakText)
                    .onChange(of: secondBreakText, perform: { newValue in
                        if(secondBreakText.count == 4) {
                            isInputtedSecondBreakText = true
                        } else {
                            isInputtedSecondBreakText = false
                        }
                    })
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                TextField("1234", text: $thirdBreakText)
                    .onChange(of: thirdBreakText, perform: { newValue in
                        if(thirdBreakText.count == 4) {
                            isInputtedThirdBreakText = true
                        } else {
                            isInputtedThirdBreakText = false
                        }
                    })
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }.padding()

            // TODO: 連携前の設定つくる
//            Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
//                Text("連携前に自分のデータを削除する")
//            }.padding()

            // TODO: 今は強引に連携してるけど、連携の申請して承認したら連携なるようにしよう
            Button(action: {
                Task {
                    let shareNumber = firstBreakText+secondBreakText+thirdBreakText
                    await connectPartnerViewModel.connectPartner(partnerShareNumber: shareNumber)
                }
            }) {
                Text("連携する")
            }
            .disabled(!(isInputtedFirstBreakText&&isInputtedSecondBreakText&&isInputtedThirdBreakText))
        }
    }

}

//struct ConnectView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConnectPartnerView()
//    }
//}
