//
//  String.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/01.
//

import Foundation

extension String {
    func splitInto(_ length: Int) -> [String] {
        var str = self
        for i in 0 ..< (str.count - 1) / max(length, 1) {
            str.insert(",", at: str.index(str.startIndex, offsetBy: (i + 1) * max(length, 1) + i))
        }
        return str.components(separatedBy: ",")
    }
}
