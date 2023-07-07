//
//  EnvironmentObjectForSelectedEditTransactionIndex.swift
//  CommonWallet
//

import Foundation

/*
 EnvironmentObjectでSelectedIndexを利用しないと、編集を選択したトランザクションが編集できない。
 常にインデックスが0のトランザクションを編集することになる。
 なぜなら、.sheetの中に入れたViewは、通常、親Viewがレンダリングされる際に生成されるため、常に新しいselectedEditTransactionIndexが利用ない
 */
class SelectedEditTransaction: ObservableObject {
    @Published var index = 0
}
