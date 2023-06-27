//
//  AllLogView.swift
//  CommonWallet
//

import SwiftUI
import Parchment

struct AllLogView: View {

    @ObservedObject var viewModel: AllLogViewModel
    @State var currentIndex: Int = 0
    @State var isSettingView = false
    // UserDefaults
    @AppStorage(UserDefaultsKey().userName) private var myUserName = String()
    @AppStorage(UserDefaultsKey().myIconData) private var myIconData = Data()
    // 画像のSystemImage
    private let imageNameProperty = ImageNameProperty()

    var body: some View {

        let pagingOptions = initPagingOption()

        NavigationView {
            VStack {

                ZStack {

                    Rectangle()
                        .frame(width: 320, height: 70)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 4))
                        .foregroundColor(.white)
                        .cornerRadius(20)

                    HStack {
                        Text("合計 \(42423)円").padding()
                    }

                }.padding()

                PageView(options: pagingOptions, items: viewModel.pagingIndexItems, selectedIndex: $viewModel.selectedIndex) { item in
                    LogListView(allLogViewModel: self.viewModel, itemIndex: item.index)
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                }) {
                    //Image(systemName: "trash")
                    Text("履歴")
                        .foregroundColor(Color.black)
                        .font(.title3)

                }, trailing: HStack {
                    Button(action: {
                        print("aa")
                        self.isSettingView = true
                    }) {
                        Image(uiImage: UIImage(data: myIconData) ?? UIImage(named: imageNameProperty.iconNotFound)!)
                            .resizable()
                            .scaledToFill()
                            .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28, alignment: .center)
                            .clipShape(Circle()) // 正円形に切り抜く
                        Text(myUserName)
                            .foregroundColor(Color.black)
                    }
                    .sheet(isPresented: self.$isSettingView) {
                        SettingView(viewModel: SettingViewModel(userDefaultsManager: UserDefaultsManager()), isShowSettingView: $isSettingView)
                    }
                }
            )
        }
    }

    func initPagingOption() -> PagingOptions {
        var pagingOptions = PagingOptions()
        pagingOptions.textColor = .gray
        pagingOptions.selectedTextColor = .black
        pagingOptions.indicatorColor = .black
        return pagingOptions
    }

}

struct AllLogView_Previews: PreviewProvider {
    static var previews: some View {
        AllLogView(viewModel: AllLogViewModel())
    }
}
