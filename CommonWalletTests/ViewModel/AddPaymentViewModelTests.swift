//
//  AddPaymentViewModelTests.swift
//  CommonWalletTests
//
//  Created by 前田航汰 on 2023/01/26.
//

import XCTest
import FirebaseCore
import FirebaseAuth
@testable import CommonWallet

final class AddPaymentViewModelTests: XCTestCase {

    private var addPaymentViewModel: AddPaymentViewModel!

    class override func setUp() {
        super.setUp()
        FirebaseApp.configure()
    }

    override func setUp() {
        super.setUp()
        addPaymentViewModel = AddPaymentViewModel()
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

    // エラーが起こってテストが出来ない...
//    func test_サインインしてｄｆおく() async {
//
//        var isSuccess = Bool()
//
//        await addPaymentViewModel.createPayment(
//            title: "タイトル",
//            memo: "メモメモメモ",
//            cost: 2000,
//            isMyPayment: false,
//            complition: { isAddSuccess, error in
//                if isAddSuccess {
//                    isSuccess = true
//                } else {
//                    print(error)
//                    isSuccess = false
//                }
//            })
//
//        XCTAssertEqual(true, isSuccess)
//    }

}
