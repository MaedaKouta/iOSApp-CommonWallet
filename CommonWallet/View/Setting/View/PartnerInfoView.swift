//
//  ContentView.swift
//  CommonWallet
//

import SwiftUI

struct PartnerInfoView: View {

    // presentationMode.wrappedValue.dismiss() で画面戻れる
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: PartnerInfoViewModel

    // UserDefaults
    @AppStorage(UserDefaultsKey().partnerShareNumber) private var partnerShareNumber = String()
    @AppStorage(UserDefaultsKey().partnerName) private var partnerName = String()
    // Alert
    @State private var isDisconnectAlert = false
    // PKHUD
    @State private var isPKHUDProgress = false
    @State private var isPKHUDSuccess = false
    @State private var isPKHUDError = false

    @State private var isShareNumberCopyDoneAlert: Bool = false

    var body: some View {
        VStack {

            List {
                Section {
                    // After tapping: 共有番号のクリップボードコピー, アラート表示
                    Button(action: {
                        UIPasteboard.general.string = partnerShareNumber
                        isShareNumberCopyDoneAlert = true
                    }, label: {
                        HStack {
                            Text("連携番号")
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(partnerShareNumber.splitBy4Digits(betweenText: " "))
                                .textSelection(.enabled)
                                .lineLimit(0)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.gray)
                            Image(systemName: "square.on.square")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.gray)
                        }
                    })
                    HStack {
                        Text("ユーザー名")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(partnerName)
                            .textSelection(.enabled)
                            .lineLimit(0)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.gray)
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
        .alert("完了", isPresented: $isShareNumberCopyDoneAlert){
            Button("OK"){}
        } message: {
            Text("クリップボードにコピーしました")
        }
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
