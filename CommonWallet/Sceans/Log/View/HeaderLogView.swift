//
//  LogHeaderView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import SwiftUI

struct HeaderLogView: View {

    @State private var isAccountView = false

    var body: some View {

//        HStack {
//            Text("12月22日 日曜日")
//                .foregroundColor(.gray)
//                .font(.system(size: 14))
//                .padding(16)
//            Spacer()
//        }.frame(height: 16, alignment: .topLeading)

        HStack {
            Text("精算済み履歴")
                .font(.title)
                .fontWeight(.bold)
                .padding(16)
            Spacer()
            Button ( action: {
                isAccountView = true
            }) {
                Image("SampleIcon")
                    .resizable()
                    .scaledToFill()
                    .overlay(RoundedRectangle(cornerRadius: 75).stroke(Color.gray, lineWidth: 1))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36, alignment: .center)
                    .clipShape(Circle()) // 正円形に切り抜く
                    .padding(.trailing, 16)
            }
            .sheet(isPresented: self.$isAccountView) {
                // trueになれば下からふわっと表示
                SettingView()
            }
            // 下の1行でListをアイコンボタンしかタップできなくしている
            .buttonStyle(BorderlessButtonStyle())
        }
    }

}

struct LogHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderLogView()
    }
}
