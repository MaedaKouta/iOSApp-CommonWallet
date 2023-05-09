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

        NavigationView {
            VStack {
                PageView(items: allLogViewModel.pagingIndexItems, selectedIndex: $allLogViewModel.selectedIndex) { item in
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
                        SettingView(isShowSettingView: $isSettingView)
                    }
                }
            )
        }
    }
}

struct ListItems: View {

    @ObservedObject var allLogViewModel: AllLogViewModel
    var itemIndex: Int

    var body: some View {

        VStack {

            HStack {
                Text("合計 \(42423)円").padding()
            }

            List {
                ForEach((0 ..< allLogViewModel.resolvedTransactionsByMonth[itemIndex].count).reversed(),  id: \.self) { index in

                    HStack {
                        Text(String(allLogViewModel.resolvedTransactionsByMonth[itemIndex][index].amount) + "円")
                        Text(allLogViewModel.resolvedTransactionsByMonth[itemIndex][index].title)
                        Text(allLogViewModel.resolvedTransactionsByMonth[itemIndex][index].createdAt.description)
                        Spacer()
                    }
                    .foregroundColor(.black)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        print(index)
                    }
                }
            }.onAppear {
                Task {
                    try await allLogViewModel.fetchTransactions()
                }
            }
        }
    }
}



//struct AllLogView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllLogView()
//    }
//}
