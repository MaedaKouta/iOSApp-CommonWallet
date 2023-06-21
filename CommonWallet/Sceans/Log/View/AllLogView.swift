//
//  AllLogView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import SwiftUI
import Parchment

struct AllLogView: View {

    @ObservedObject var allLogViewModel: AllLogViewModel
    @State var currentIndex: Int = 0
    @State var isSettingView =  false

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

                PageView(options: pagingOptions, items: allLogViewModel.pagingIndexItems, selectedIndex: $allLogViewModel.selectedIndex) { item in
                    ListItems(allLogViewModel: self.allLogViewModel, itemIndex: item.index)
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    print("aa")
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
                        Image("SampleIcon")
                            .resizable()
                            .scaledToFill()
                            .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28, alignment: .center)
                            .clipShape(Circle()) // 正円形に切り抜く
                        Text("kota")
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

struct ListItems: View {

    @ObservedObject var allLogViewModel: AllLogViewModel
    var itemIndex: Int

    var body: some View {

        VStack {

            List {

                if allLogViewModel.resolvedTransactionsByMonth[itemIndex].count == 0 {
                    VStack {
                        Image("Sample2")
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top)
                        Text("リストが空です")
                            .foregroundColor(.gray)
                    }
                    .listRowSeparator(.hidden)
                    .padding(.top, 100)
                } else {

                    ForEach((0 ..< allLogViewModel.resolvedTransactionsByMonth[itemIndex].count).reversed(),  id: \.self) { index in

                        HStack {

                            if allLogViewModel.resolvedTransactionsByMonth[itemIndex][index].debtorId != allLogViewModel.myUserId {
                                Image("SampleIcon")
                                    .resizable()
                                    .scaledToFill()
                                    .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 28, height: 28, alignment: .center)
                                    .clipShape(Circle())
                            } else {
                                Image("SamplePartnerIcon")
                                    .resizable()
                                    .scaledToFill()
                                    .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 28, height: 28, alignment: .center)
                                    .clipShape(Circle())
                            }

                            VStack(alignment: .leading) {
                                Text(self.dateToString(date: allLogViewModel.resolvedTransactionsByMonth[itemIndex][index].createdAt))
                                    .font(.caption)
                                    .foregroundColor(Color.gray)
                                Text(allLogViewModel.resolvedTransactionsByMonth[itemIndex][index].title)
                            }

                            Spacer()

                            VStack(alignment: .trailing) {
                                Text("¥\(allLogViewModel.resolvedTransactionsByMonth[itemIndex][index].amount)")
                            }
                        }
                        .padding(3)
                        .foregroundColor(.black)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print(index)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .onAppear {
                Task {
                    try await allLogViewModel.fetchTransactions()
                }
            }
            .refreshable {
                await Task.sleep(1000000000)
            }
        }
    }

    private func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy/MM/dd"

        return dateFormatter.string(from: date)
    }

    private func dateToDetailString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"

        return dateFormatter.string(from: date)
    }
}



//struct AllLogView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllLogView()
//    }
//}
