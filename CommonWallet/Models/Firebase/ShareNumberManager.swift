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
     16桁のうち、
     0-4桁：8888 - yyyy
     5-8桁：2222 - mmdd
     9-16桁：ユーザー数
     */
    func createShareNumber() async -> String {

        var firstQuarterNumber: String = ""
        var secoundQuarterNumber: String = ""
        var lastHalfNumber: String = ""

        // 前半8桁
        let date = Date()
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        let dating: Int = Int((String(month) + String(day))) ?? 0
        firstQuarterNumber = String(format: "%04d", 8888 - year)
        secoundQuarterNumber = String(format: "%04d", 2222 - dating)

        // 後半8桁
        await fetchUserCount(completion: { count, error in
            if let count = count {
                print(count)
                lastHalfNumber = String(format: "%08d", count)
            } else {
                print(error as Any)
            }
        })

        return firstQuarterNumber + secoundQuarterNumber + lastHalfNumber
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

    private func createRandomNumberString(_ length: Int) -> String {
        let randomInt = Int.random(in: 1..<9999)
        return String(format: "%04d", randomInt)
    }

}
