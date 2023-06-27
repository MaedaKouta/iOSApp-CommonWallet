//
//  LogHeaderView.swift
//  CommonWallet
//

import SwiftUI

struct HeaderLogView: View {

    @State private var isSettingView = false
    // 画像のSystemImage
    private let imageNameProperty = ImageNameProperty()
    // UserDefaults
    @AppStorage(UserDefaultsKey().myIconData) private var myIconData = Data()

    var body: some View {

        HStack {
            Text("精算済み履歴")
                .font(.title)
                .fontWeight(.bold)
                .padding(16)
            Spacer()
            Button ( action: {
                isSettingView = true
            }) {
                Image(uiImage: UIImage(data: myIconData) ?? UIImage(named: imageNameProperty.iconNotFound)!)
                    .resizable()
                    .scaledToFill()
                    .overlay(RoundedRectangle(cornerRadius: 75).stroke(Color.gray, lineWidth: 1))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36, alignment: .center)
                    .clipShape(Circle()) // 正円形に切り抜く
                    .padding(.trailing, 16)
            }
            .sheet(isPresented: self.$isSettingView) {
                // trueになれば下からふわっと表示
                SettingView(viewModel: SettingViewModel(userDefaultsManager: UserDefaultsManager()), isShowSettingView: $isSettingView)
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
