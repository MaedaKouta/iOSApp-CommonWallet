//
//  SharedNumber.swift
//  CommonWallet
//

import Foundation
import Firebase
import FirebaseFirestore

class ShareNumberManager: ShareNumberManaging {

    private let db = Firestore.firestore()

    /*
     12桁をランダムで生成
     */
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
            print("Firebase Check Duplicate Number Error")
        }

        return false
    }

    // 12桁の乱数を生成する関数
    private func createRandom16NumberString() -> String {
        let firstBreak = String(format: "%04d", Int.random(in: 0..<9999))
        let secondBreak = String(format: "%04d", Int.random(in: 0..<9999))
        let thirdBreak = String(format: "%04d", Int.random(in: 0..<9999))

        return firstBreak + secondBreak + thirdBreak
    }

}
