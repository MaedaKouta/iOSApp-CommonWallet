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

    var body: some View {

        VStack {
            PageView(items: allLogViewModel.pagingIndexItems, selectedIndex: $allLogViewModel.selectedIndex) { item in

                VStack {
                    // もし、paidPaymentsByMonth[selectedIndex]に値がなければ何もしない
                    if allLogViewModel.paidPaymentsByMonth[item.index].count == 0 {
                        Text("値がありません")
                    } else {
                        List {
                            ForEach(0 ..< allLogViewModel.paidPaymentsByMonth[item.index].count,  id: \.self) { index in

                                HStack {
                                    Text(String(allLogViewModel.paidPaymentsByMonth[item.index][index].cost) + "円")
                                    Text(allLogViewModel.paidPaymentsByMonth[item.index][index].title)
                                    Spacer()
                                }
                                .foregroundColor(.black)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    print(index)
                                }
                            }
                        }//Listここまで
                    }//if文ここまで
                }//VStackここまで
            }
        }
        .onAppear{
            //allLogViewModel.featchPayments()
            print(allLogViewModel.paidPaymentsByMonth)
        }
    }
}

struct AllLogView_Previews: PreviewProvider {
    static var previews: some View {
        AllLogView()
    }
}
