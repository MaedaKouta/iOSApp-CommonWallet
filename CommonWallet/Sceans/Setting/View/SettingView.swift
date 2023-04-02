//
//  AccountView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct SettingView: View {

    @ObservedObject var settingViewModel = SettingViewModel()

    @Binding var isShowSettingView: Bool
    @State private var color: Color = .white
    @State private var isActive: Bool = false

    @State private var connectText: String = ""
    @State private var isSelectionShareNumber = false

    @State private var test = false

    var body: some View {
        NavigationView {
            VStack {
                List {

                    Section {
                        NavigationLink(destination: AccountView(isShowSettingView: $isShowSettingView) ) {
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

                        Button(action: {
                            // TODO: 「クリップボードにコピーしました」みたいなアラート出そう
                            UIPasteboard.general.string = settingViewModel.shareNumber
                            print("クリップボードコピー：\(String(describing: UIPasteboard.general.string))")
                        }, label: {
                            HStack {
                                Text("My共有番号")
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(settingViewModel.shareNumber)
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

                    } header: {
                        Text("アカウント")
                    }

                    Section {

                        HStack {
                            Text("パートナーの名前")
                            NavigationLink(destination: ChangePartnerNameView(isShowSettingView: $isShowSettingView) ) {
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
                                        UnConnectPartnerView(isShowSettingView: $isShowSettingView)
                                    } else {
                                        ConnectPartnerView(isShowSettingView: $isShowSettingView)
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

                }// Listここまで
                .scrollContentBackground(.visible)
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
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
}

//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingView(isShowSettingView: true)
//    }
//}
