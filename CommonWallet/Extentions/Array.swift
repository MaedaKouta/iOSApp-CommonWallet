//
//  Array.swift
//  CommonWallet
//

import Foundation

extension Array {

    /**
     インデックスが配列の範囲内の場合は配列の要素を返す
     インデックスが配列の範囲外の場合はnilを返す
    */
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    /**
     配列を与えられた数ごとに分割し、二次元配列として返す
     - parameter chunkSize: 区切る数
     */
    func splitIntoChunks(ofSize chunkSize: Int) -> [[Element]] {
        var result: [[Element]] = []
        var currentIndex = 0

        while currentIndex < self.count {
            let endIndex = Swift.min(currentIndex + chunkSize, self.count)
            let chunk = Array(self[currentIndex..<endIndex])
            result.append(chunk)
            currentIndex += chunkSize
        }

        return result
    }

}
