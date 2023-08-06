//
//  String.swift
//  CommonWallet
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

    /*
     4桁ごとに betweenText を挿入して分割する
     betweenTextには"-"などを指定する
     */
    func splitBy4Digits(betweenText: String) -> String {
        let textArray = self.splitInto(4)
        let splitText = textArray.joined(separator: betweenText)
        return splitText
    }

}
