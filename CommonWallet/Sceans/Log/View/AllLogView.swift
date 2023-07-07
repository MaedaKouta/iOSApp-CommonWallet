//
//  AllLogView.swift
//  CommonWallet
//

import SwiftUI
import Parchment

struct AllLogView: View {

    @EnvironmentObject var transactionData: TransactionData

    @State var selectedIndex = 0
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
                        Text("合計 \(transactionData.resolvedTransactionsAmountByMonth[transactionData.selectedResolvedPagingIndex])円")
                            .animation(.default)
                            .padding()
                    }

                }.padding()

                PageView(options: pagingOptions, items: transactionData.resolvedPagingIndexItems, selectedIndex: $transactionData.selectedResolvedPagingIndex) { item in
                    LogListView(viewModel: LogListsViewModel(fireStoreTransactionManager: FireStoreTransactionManager()), itemIndex: item.index)
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                leading: HStack {
                    HStack {
                        Text("履歴")
                            .foregroundColor(Color.black)
                            .font(.title2)
                    }
                }, trailing: HStack {
                    Button(action: {
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

    private func initPagingOption() -> PagingOptions {
        var pagingOptions = PagingOptions()
        pagingOptions.textColor = .gray
        pagingOptions.selectedTextColor = .black
        pagingOptions.indicatorColor = .black
        return pagingOptions
    }

}

struct AllLogView_Previews: PreviewProvider {
    static var previews: some View {
        AllLogView()
    }
}
