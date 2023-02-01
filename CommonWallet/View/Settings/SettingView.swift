//
//  AccountView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct SettingView: View {
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
                                    Text("名前")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("メールアドレス")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    } header: {
                        Text("アカウント")
                    }

                    Section {
                        HStack {
                            Text("共有番号")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("2345 4513 4553 4355")
                                .lineLimit(0)
                                .minimumScaleFactor(0.5)
                        }
                        Text("パートナー")
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
