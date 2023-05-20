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

    @State private var isChangePartnerNameView = false
    @State private var test = false

    @State private var isWebView = false
    private let feedbackUrl = "https://forms.gle/ubpATWSmMu5qY4v78"
    private let twitterUrl = "https://twitter.com/kota_org"
    private let privacyUrl = "https://kota1970.notion.site/c6a23dc083cf47d6aecef0e61035aaa2"
    private let ruleUrl = "https://kota1970.notion.site/5125398bba6541558f2bd4479627cb37"

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
                            NavigationLink(destination: ChangePartnerNameView(changePartnerNameViewModel: ChangePartnerNameViewModel(), isChangePartnerNameView: $isChangePartnerNameView), isActive: $isChangePartnerNameView) {
                                Text(settingViewModel.partnerName)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .onAppear{
                                settingViewModel.reloadPartnerName()
                            }
                        }

                        HStack {
                            Text("パートナー")

                            NavigationLink(destination: {
                                VStack {
                                    if settingViewModel.isConnectPartner() {
                                        UnConnectPartnerView(unConnectPartnerViewModel: UnConnectPartnerViewModel())
                                    } else {
                                        ConnectPartnerView(connectPartnerViewModel: ConnectPartnerViewModel())
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
                        // TODO: リリース後に開放
                        //Text("アプリをレビューする")

                        if let url = URL(string: feedbackUrl) {
                            openWebInside(url: url, text: "フィードバックを送る")
                        }

                        if let url = URL(string: twitterUrl) {
                            openWebOutside(url: url, text: "開発者のTwitter")
                        }

                        if let url = URL(string: ruleUrl) {
                            openWebInside(url: url, text: "利用規約")
                        }

                        if let url = URL(string: privacyUrl) {
                            openWebInside(url: url, text: "プライバシーポリシー")
                        }

                        openLicenseView()

                        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                            HStack {
                                Text("バージョン")
                                Spacer()
                                Text(version)
                                    .foregroundColor(.gray)
                            }
                        }

                    } header: {
                        Text("情報")
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

    // アプリから抜けてSafariでリンクを開く
    private func openWebOutside(url: URL, text: String) -> some View {
        return Link(destination: url, label: {
            HStack{
                Text(text)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "arrowshape.turn.up.right")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.gray)
            }
        })
    }

    // アプリ内でWebを開く
    private func openWebInside(url: URL, text: String) -> some View {
        NavigationLink(destination: WebView(url: url)) {
            Text(text)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // ライセンス画面を開く
    private func openLicenseView() -> some View {
        NavigationLink(destination: LicenseView() ) {
            Text("ライセンス")
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

}

//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingView(isShowSettingView: true)
//    }
//}
