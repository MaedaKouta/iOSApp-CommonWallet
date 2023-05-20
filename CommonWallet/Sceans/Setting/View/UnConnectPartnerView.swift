//
//  ContentView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import SwiftUI

struct UnConnectPartnerView: View {

    @ObservedObject var unConnectPartnerViewModel: UnConnectPartnerViewModel

    @State private var text = ""

    var body: some View {
        VStack {

            List {

                Section {
                    HStack {
                        Text("連携番号")
                        TextField("1234 5678 9123", text: $text)
                    }
                }

                Section {
                    HStack {
                        Text("連携番号")
                        TextField("1234 5678 9123", text: $text)
                    }
                }

                Section {
                    Button(action: {
                        Task {
                            await unConnectPartnerViewModel.deletePartner()
                        }
                    }) {
                        HStack {
                            Text("連携を解除する")
                                .foregroundColor(.red)
                        }
                    }
                }
            }

            Text("パートナーの番号")
            Text(unConnectPartnerViewModel.partnerShareNumber)

            Button(action: {
                Task {
                    await unConnectPartnerViewModel.deletePartner()
                }
            }) {
                Text("連携を解除する")
            }

        }
    }

}

struct UnConnectView_Previews: PreviewProvider {
    static var previews: some View {
        UnConnectPartnerView(unConnectPartnerViewModel: UnConnectPartnerViewModel())
    }
}
