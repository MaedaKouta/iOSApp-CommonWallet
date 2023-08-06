//
//  SignInViewModelTests.swift
//  CommonWalletTests
//
//  Created by 前田航汰 on 2023/01/21.
//

import XCTest
import FirebaseCore
import FirebaseAuth
@testable import CommonWallet

final class SignInViewModelTests: XCTestCase {

    private var signInViewModel: SignInViewModel!

    class override func setUp() {
        super.setUp()
        FirebaseApp.configure()
    }

    override func setUp() {
        super.setUp()
        signInViewModel = SignInViewModel()
    }

    // MARK: - signIn関数
    func test_SignInが成功すること() async {
        let mailAdress = "test@testmail.com"
        let password = "000000"

        await signInViewModel.signIn(email: mailAdress, password: password, complition: { isSuccess, _ in
            XCTAssertEqual(isSuccess, true)
        })
    }

    func test_SignInがメール形式ミスで失敗してメッセージが返ってくること() async {
        let mailAdress = "test"
        let password = "000000"

        await signInViewModel.signIn(email: mailAdress, password: password, complition: { isSuccess, message in
            XCTAssertEqual(isSuccess, false)
            XCTAssertEqual(message, "メールアドレスの形式が違います。")
        })
    }

    func test_SignInがパスワードミスで失敗してメッセージが返ってくること() async {
        let mailAdress = "test@testmail.com"
        let password = "0000000000000000000000000000000000000000"

        await signInViewModel.signIn(email: mailAdress, password: password, complition: { isSuccess, message in
            XCTAssertEqual(isSuccess, false)
            XCTAssertEqual(message, "メールアドレス、またはパスワードが間違っています")
        })
    }

}
