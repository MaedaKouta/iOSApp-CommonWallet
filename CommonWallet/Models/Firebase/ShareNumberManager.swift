//
//  SharedNumber.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/30.
//

import Foundation
import Firebase
import FirebaseFirestore

class ShareNumberManager {

    private let db = Firestore.firestore()

    /*
     12桁をランダムで生成
     */
    // TODO: 一生繰り返し処理なったら大変だから、ループの制限作ろう
    func createShareNumber() async -> String {

        var shareNumber = createRandom16NumberString()
        var duplicateCheck = await checkDuplicateNumber(number: shareNumber)

        // もしshareNumberが重複した場合に作り直す処理
        while !duplicateCheck {
            sleep(1)
            shareNumber = createRandom16NumberString()
            duplicateCheck = await checkDuplicateNumber(number: shareNumber)
        }

        return shareNumber

    }

    private func checkDuplicateNumber(number: String) async -> Bool {

        do {
            let snapShots = try await db.collection("Users")
                .whereField("shareNumber", isEqualTo: number)
                .getDocuments()

            // もしドキュメントに同じ値が存在しなければtrueを返す
            if snapShots.documents.count == 0 {
                return true
            } else {
                return false
            }
        } catch {
            // TODO: 例外処理
        }

        return false
    }

    // 12桁の乱数を生成する関数
    private func createRandom16NumberString() -> String {
        let firstBreake = String(format: "%04d", Int.random(in: 0..<9999))
        let secondBreake = String(format: "%04d", Int.random(in: 0..<9999))
        let thirdBreake = String(format: "%04d", Int.random(in: 0..<9999))

        return firstBreake + secondBreake + thirdBreake
    }

}
