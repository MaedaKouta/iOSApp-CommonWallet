//
//  ContentView.swift
//  CommonWallet
//

import SwiftUI

struct PartnerInfoView: View {

    // presentationMode.wrappedValue.dismiss() で画面戻れる
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: PartnerInfoViewModel

    // Alert
    @State private var isDisconnectAlert = false
    // PKHUD
    @State private var isPKHUDProgress = false
    @State private var isPKHUDSuccess = false
    @State private var isPKHUDError = false

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
                            isDisconnectAlert = true
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

        }
        .PKHUD(isPresented: $isPKHUDProgress, HUDContent: .progress, delay: .infinity)
        .PKHUD(isPresented: $isPKHUDSuccess, HUDContent: .success, delay: 1.0)
        .PKHUD(isPresented: $isPKHUDError, HUDContent: .error, delay: 1.0)
        .alert("連携解除", isPresented: $isDisconnectAlert){
            Button("キャンセル"){
            }
            Button("OK"){
                isPKHUDProgress = true
                Task {
                    do {
                        try await viewModel.deletePartner()
                        isPKHUDProgress = false
                        isPKHUDSuccess = true
                        // PKHUD Suceesのアニメーションが1秒経過してから元の画面に戻る
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            presentationMode.wrappedValue.dismiss()
                            isPKHUDSuccess = false
                        }
                    } catch {
                        isPKHUDProgress = false
                        isPKHUDError = true
                    }
                }
            }
        } message: {
            Text("パートナーとの連携を解除しますか？相手も連携が解除されます。")
        }
    }

}

struct UnConnectView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerInfoView(viewModel: PartnerInfoViewModel())
    }
}
