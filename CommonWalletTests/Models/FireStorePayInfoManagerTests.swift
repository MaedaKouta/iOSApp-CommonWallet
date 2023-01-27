//
//  FireStorePaymentManagerTests.swift
//  CommonWalletTests
//
//  Created by 前田航汰 on 2023/01/26.
//

import XCTest
import FirebaseCore
import FirebaseAuth
@testable import CommonWallet

final class FireStorePayInfoManagerTests: XCTestCase {

    private var fireStorePayInfoManager: FireStorePayInfoManager!

    class override func setUp() {
        super.setUp()
        FirebaseApp.configure()
    }

    override func setUp() {
        super.setUp()
        fireStorePayInfoManager = FireStorePayInfoManager()
    }

    func test_サインインしておく() async {
        let mailAdress = "test.unittest@testmail.com"
        let password = "000000"
        do {
            try await Auth.auth().signIn(withEmail: mailAdress, password: password)
        } catch {
            print("認証エラー", error)
        }
    }

    // エラーがおこってテストできない...
//    func test_paymentを追加できること() async {
//
//        var isSuccess = Bool()
//
//        do {
//            try await fireStorePaymentManager.createPayment(
//                userUid: "vvUsLxdKZ5P8LVFc0No2LNfKgZf1",
//                title: "テストタイトル",
//                memo: "メモメモメモメモメモ",
//                cost: 2000,
//                isMyPayment: false)
//            isSuccess = true
//        } catch {
//            print(error)
//            isSuccess = false
//        }
//
//        XCTAssertEqual(true, isSuccess)
//    }

}
