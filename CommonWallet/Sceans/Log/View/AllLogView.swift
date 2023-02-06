//
//  AllLogView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import SwiftUI
import Parchment

struct AllLogView: View {

    @State var items = [
        PagingIndexItem(index: 0, title: "1月"),
        PagingIndexItem(index: 1, title: "2月"),
        PagingIndexItem(index: 2, title: "3月"),
        PagingIndexItem(index: 3, title: "4月"),
        PagingIndexItem(index: 4, title: "5月"),
        PagingIndexItem(index: 5, title: "6月"),
    ]
    @State var selectedIndex: Int = 5

    var body: some View {

        VStack {
            PageView(items: items, selectedIndex: $selectedIndex) { item in
                Text(item.title)
            }
        }
    }
}

struct AllLogView_Previews: PreviewProvider {
    static var previews: some View {
        AllLogView()
    }
}
