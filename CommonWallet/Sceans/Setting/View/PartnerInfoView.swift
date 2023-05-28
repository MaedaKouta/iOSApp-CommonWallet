//
//  ContentView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import SwiftUI

struct PartnerInfoView: View {

    @ObservedObject var viewModel: PartnerInfoViewModel

    @State private var isDisConnectPartnerAlert = false
    @State private var text = ""

    var body: some View {
        VStack {

            List {
                Section {
                    HStack {
                        Text("連携番号")
                        Spacer()
                        Text(viewModel.partnerShareNumber)
                    }
                    HStack {
                        Text("登録名")
                        Spacer()
                        Text(viewModel.partnerName)
                    }
                    HStack {
                        Text("本端末での表示名")
                        Spacer()
                        Text(viewModel.partnerModifiedName)
                    }
                } header: {
                    Text("パートナー情報")
                }

                Section {
                    Button(action: {
                        Task {
                            isDisConnectPartnerAlert = true
                        }
                    }) {
                        HStack {
                            Text("連携を解除する")
                                .foregroundColor(.red)
                        }
                    }
                } footer: {
                    Text("パートナーとの連携を解除できます。解除すると、相手の連携も強制的に解除されます。")
                }
            }

        }.alert("連携解除", isPresented: $isDisConnectPartnerAlert){
            Button("キャンセル"){
            }
            Button("OK"){
                Task {
                    await viewModel.deletePartner()
                }
            }
        } message: {
            Text("パートナーとの連携を解除しますか？強制的に相手も連携が解除されます。")
        }
    }

}

struct UnConnectView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerInfoView(viewModel: PartnerInfoViewModel())
    }
}
