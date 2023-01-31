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
     16桁をランダムで生成
     */
    func createShareNumber() async -> String {


    }

    private func fetchUserCount(completion: @escaping(Int?, Error?) -> Void) async {

        var count = Int()

        // 値をFireStoreから取得
        db.collection("SignUpUserNumber")
            .addSnapshotListener { snapShots, error in

                if let error = error {
                    completion(nil, error)
                    return
                }
                print("FirestoreからUserCountの取得に成功")

                snapShots?.documents.forEach({ snapShot in
                    let data = snapShot.data()
                    guard let userNumber = data["userNumber"] as? Int else {
                        completion(nil, error)
                        return
                    }
                    count = userNumber
                })
            }

        // 値をFireStoreにセット
        count += 1
        let signUpUserNumber: Dictionary<String, Any> = ["userNumber": count]
        do {
            try await db.collection("SignUpUserNumber").document("SignUpUserNumber").setData(signUpUserNumber)
            completion(count, nil)
        } catch {
            completion(nil, error)
        }
    }

    // 16桁の乱数を生成する関数
    private func createRandom16NumberString() -> String {
        let firstQuarter = String(format: "%04d", Int.random(in: 0..<9999))
        let secondQuarter = String(format: "%04d", Int.random(in: 0..<9999))
        let thirdQuarter = String(format: "%04d", Int.random(in: 0..<9999))
        let forthQuarter = String(format: "%04d", Int.random(in: 0..<9999))

        return firstQuarter + secondQuarter + thirdQuarter + firstQuarter
    }

}
