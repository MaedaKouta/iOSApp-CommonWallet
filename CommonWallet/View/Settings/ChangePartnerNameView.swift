//
//  ChangePartnerNameView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import SwiftUI

struct ChangePartnerNameView: View {

    @State private var partnerName: String = ""
    @State private var isInputPartnerName: Bool = false

    var body: some View {

        VStack {
            TextField("1234", text: $partnerName)
                .onChange(of: partnerName, perform: { newValue in
                    if partnerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        isInputPartnerName = false
                    } else {
                        isInputPartnerName = true
                    }
                })
                .textFieldStyle(.roundedBorder)
                .padding()

            Button(action: {
            }) {
                Text("変更する")
            }
            .disabled(!isInputPartnerName)

        }


    }
}

struct ChangePartnerNameView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePartnerNameView()
    }
}
