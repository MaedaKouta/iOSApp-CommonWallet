//
//  AccountView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct SettingView: View {

    @StateObject var viewModel = SettingViewModel()

    @Binding var isShowSettingView: Bool
    @State private var color: Color = .white
    @State private var isActive: Bool = false
    @State private var isCopyDoneAlert: Bool = false

    @State private var connectText: String = ""
    @State private var isSelectionShareNumber = false

    @State private var isChangePartnerNameView = false
    @State private var isConnectPartnerView = false
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
                                    Text(viewModel.userName)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(viewModel.userEmail)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }

                        Button(action: {
                            UIPasteboard.general.string = viewModel.shareNumber
                            isCopyDoneAlert = true
                        }, label: {
                            HStack {
                                Text("My共有番号")
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(viewModel.shareNumber)
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
                            Text("表示名")
                            NavigationLink(destination: PartnerNameEditView(viewModel: PartnerNameEditViewModel())) {
                                Text(viewModel.partnerModifiedName)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .onAppear{
                                viewModel.reloadPartnerName()
                            }
                        }

                        // 連携情報を、パートナーと接続済みかで表示なよう変える
                        // 下のような広い条件分岐にしないと、挙動がおかしくなる
                        if viewModel.isConnectPartner() {
                            HStack {
                                Text("連携情報")
                                NavigationLink(destination: {
                                    PartnerInfoView(viewModel: PartnerInfoViewModel())
                                }, label: {
                                    Text(connectText)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .onAppear {
                                            connectText = "1234 - 5678 - 9123"
                                        }
                                })
                            }
                        } else {
                            HStack {
                                Text("連携情報")
                                NavigationLink(destination: {
                                    ConnectPartnerView(viewModel: ConnectPartnerViewModel())
                                }, label: {
                                    Text(connectText)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .onAppear {
                                            connectText = "未連携"
                                        }
                                })
                            }
                        }
                    } header: {
                        Text("パートナー")
                    } footer: {
                        Text("パートナーと連携することで、お互いに金額を操作できます。")
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
            .alert("完了", isPresented: $isCopyDoneAlert){
                Button("OK"){
                }
            } message: {
                Text("クリップボードにコピーしました")
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
