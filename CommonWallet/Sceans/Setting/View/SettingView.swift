//
//  AccountView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct SettingView: View {

    @ObservedObject var settingViewModel = SettingViewModel()
    @State private var connectText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                List {

                    Section {
                        NavigationLink(destination: AccountView() ) {
                            HStack {
                                Image("SampleIcon")
                                    .resizable()
                                    .scaledToFill()
                                    .overlay(RoundedRectangle(cornerRadius: 75).stroke(Color.gray, lineWidth: 1))
                                    .frame(width: 45, height: 45)
                                VStack {
                                    Text(settingViewModel.userName)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(settingViewModel.userEmail)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }

                        HStack {
                            Text("My共有番号")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(settingViewModel.shareNumber)
                                .lineLimit(0)
                                .minimumScaleFactor(0.5)
                        }

                    } header: {
                        Text("アカウント")
                    }

                    Section {

                        HStack {
                            Text("パートナーの名前")
                            NavigationLink(destination: ChangePartnerNameView() ) {
                                Text(settingViewModel.partnerName)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }.onAppear{
                                settingViewModel.reloadPartnerName()
                            }
                        }

                        HStack {
                            Text("パートナー")

                            NavigationLink(destination: {
                                VStack {
                                    if settingViewModel.isConnectPartner() {
                                        UnConnectPartnerView()
                                    } else {
                                        ConnectPartnerView()
                                    }
                                }
                            }, label: {
                                Text(connectText)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .onAppear {
                                        if settingViewModel.isConnectPartner() {
                                            connectText = "連携済み"
                                        } else {
                                            connectText = "未連携"
                                        }
                                    }
                            })

                        }


                    } header: {
                        Text("パートナー登録")
                    }

                    Section {
                        Text("通知")
                        Text("デフォルトカラー")
                    } header: {
                        Text("基本設定")
                    }

                    Section {
                        Text("アプリをレビューする")
                        Text("フィードバックを送る")
                        Text("開発者のTwitter")
                        Text("利用規約")
                        Text("プライバシーポリシー")
                        Text("バージョン")
                    } header: {
                        Text("端末情報")
                    }
                }

            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
