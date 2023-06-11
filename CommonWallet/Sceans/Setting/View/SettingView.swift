//
//  AccountView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct SettingView: View {

    @StateObject var viewModel: SettingViewModel
    @Binding var isShowSettingView: Bool

    // Userdefaults
    @AppStorage(UserDefaultsKey().userName) private var myUserName = String()
    @AppStorage(UserDefaultsKey().shareNumber) private var myShareNumber = String()
    @AppStorage(UserDefaultsKey().myIconData) private var myIconData = Data()
    @AppStorage(UserDefaultsKey().partnerModifiedName) private var partnerModifiedName = String()
    @AppStorage(UserDefaultsKey().partnerShareNumber) private var partnerShareNumber = String()
    @State private var imageNameProperty = ImageNameProperty()

    @State private var isShareNumberCopyDoneAlert: Bool = false

    // URL
    private let feedbackUrl = "https://forms.gle/ubpATWSmMu5qY4v78"
    private let twitterUrl = "https://twitter.com/kota_org"
    private let privacyUrl = "https://kota1970.notion.site/c6a23dc083cf47d6aecef0e61035aaa2"
    private let ruleUrl = "https://kota1970.notion.site/5125398bba6541558f2bd4479627cb37"

    var body: some View {
        NavigationView {
            List {
                accountSection()
                partnerSection()
                infoSection()
            }
            .alert("完了", isPresented: $isShareNumberCopyDoneAlert){
                Button("OK"){}
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


    // MARK: - Section
    /**
      アカウントのListSection
     - Description
        - ユーザ
        - My共有番号
     - Returns: View(Section)
     */
    private func accountSection() -> some View {
        Section {

            // タップ後: AccountViewへNavigation遷移
            NavigationLink(destination: AccountView(viewModel: AccountViewModel())) {
                HStack {
                    Image(uiImage: UIImage(data: myIconData) ?? UIImage(named: imageNameProperty.iconNotFound)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .cornerRadius(75)
                        .overlay(RoundedRectangle(cornerRadius: 75).stroke(Color.gray, lineWidth: 1))
                    VStack {
                        Text(myUserName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            // After tapping: 共有番号のクリップボードコピー, アラート表示
            Button(action: {
                UIPasteboard.general.string = myShareNumber
                isShareNumberCopyDoneAlert = true
            }, label: {
                HStack {
                    Text("My共有番号")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(myShareNumber.splitBy4Digits(betweenText: " "))
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
    }

    /**
      パートナーのListSection
     - Description
        - 表示名
        - 連携情報
     - Returns: View(Section)
     */
    private func partnerSection() -> some View {
        Section {

            // After tapping: PartnerNameEditViewへNavigation遷移
            NavigationLink(destination: PartnerNameEditView(viewModel: PartnerNameEditViewModel())) {
                HStack {
                    Text("表示名")
                    Text(partnerModifiedName)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .onAppear{
                viewModel.reloadPartnerName()
            }

            // 条件分岐: パートナーと連携済みorパートナーと未連携
            if viewModel.isConnectPartner() {
                // After tapping: PartnerInfoViewへNavigation遷移
                NavigationLink(destination: PartnerInfoView(viewModel: PartnerInfoViewModel())) {
                    HStack {
                        Text("連携情報")
                        Spacer()
                        Text(partnerShareNumber.splitBy4Digits(betweenText: " "))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            } else {
                // After tapping: ConnectPartnerViewへNavigation遷移
                NavigationLink(destination: ConnectPartnerView(viewModel: ConnectPartnerViewModel())) {
                    HStack {
                        Text("連携情報")
                        Spacer()
                        Text("未連携")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
        } header: {
            Text("パートナー")
        } footer: {
            Text("パートナーと連携することで、お互いに金額を操作できます。")
        }
    }

    /**
     基本情報のListSection
     - Description
        - フィードバック
        - 開発者のTwitter
        - 利用規約
        - プライバシーポリシー
        - ライセンス
        - バージョン
     - Returns: View(Section)
     */
    private func infoSection() -> some View {
        Section {
            if let url = URL(string: feedbackUrl) {
                openWebInsideCellView(url: url, text: "フィードバックを送る")
            }

            if let url = URL(string: twitterUrl) {
                openWebOutsideCellView(url: url, text: "開発者のTwitter")
            }

            if let url = URL(string: ruleUrl) {
                openWebInsideCellView(url: url, text: "利用規約")
            }

            if let url = URL(string: privacyUrl) {
                openWebInsideCellView(url: url, text: "プライバシーポリシー")
            }

            openLicenseCellView()

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
    }


    // MARK: - Cell
    /**
     クリック後, 外部のデフォルトブラウザでリンクを開く
     - Parameters:
        - url: URL
        - text: セルに表示されるテキスト
     - Returns: View(Cell)
     */
    private func openWebOutsideCellView(url: URL, text: String) -> some View {
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

    /**
     クリック後, NavigationLinkで画面遷移してアプリ内でリンクを開く
     - Parameters:
        - url: URL
        - text: セルに表示されるテキスト
     - Returns: View(Cell)
     */
    private func openWebInsideCellView(url: URL, text: String) -> some View {
        NavigationLink(destination: WebView(url: url)) {
            Text(text)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }


    /**
     クリック後, NavigationLinkで画面遷移してライセンスを開く
     - Returns: View(Cell)
     */
    private func openLicenseCellView() -> some View {
        NavigationLink(destination: LicenseView() ) {
            Text("ライセンス")
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(viewModel: SettingViewModel(), isShowSettingView: .constant(true))
    }
}
