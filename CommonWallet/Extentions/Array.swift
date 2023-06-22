//
//  Array.swift
//  CommonWallet
//

import Foundation

extension Array {

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
