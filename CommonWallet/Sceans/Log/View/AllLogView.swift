//
//  AllLogView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import SwiftUI
import Parchment

struct AllLogView: View {

    @ObservedObject var allLogViewModel = AllLogViewModel()
    @State var selectedIndex: Int = 5

    var body: some View {

        VStack {
            PageView(items: allLogViewModel.pagingIndexItems, selectedIndex: $selectedIndex) { item in
                //Text(item.title)

                List {
                    ForEach(0 ..< allLogViewModel.paidPayments.count,  id: \.self) { index in

                        HStack {
                            Text(String(allLogViewModel.paidPayments[index].cost) + "円")
                            Text(allLogViewModel.paidPayments[index].title)
                            Spacer()
                        }
                        .foregroundColor(.black)
                        .contentShape(Rectangle())      // 追加
                        .onTapGesture {
                            print(index)
                        }
                    }
                }
            }
        }
        .onAppear{
            allLogViewModel.featchPayments()
        }
    }
}

struct AllLogView_Previews: PreviewProvider {
    static var previews: some View {
        AllLogView()
    }
}
