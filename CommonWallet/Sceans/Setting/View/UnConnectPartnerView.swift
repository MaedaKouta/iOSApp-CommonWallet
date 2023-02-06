//
//  ContentView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import SwiftUI

struct UnConnectPartnerView: View {

    @ObservedObject var unConnectPartnerViewModel = UnConnectPartnerViewModel()

    var body: some View {
        VStack {
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
        UnConnectPartnerView()
    }
}
