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

    var body: some View {

        VStack {
            PageView(items: allLogViewModel.pagingIndexItems, selectedIndex: $allLogViewModel.selectedIndex) { item in
                ListItems(allLogViewModel: self.allLogViewModel, itemIndex: item.index)
            }
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
