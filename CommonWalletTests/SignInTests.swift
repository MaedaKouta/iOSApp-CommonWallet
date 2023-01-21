//
//  LoginTests.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/20.
//

import XCTest
import FirebaseCore
@testable import CommonWallet

final class SignInTests: XCTestCase {

    private var authManager: AuthManager!

    class override func setUp() {
        super.setUp()
        FirebaseApp.configure()
    }

    override func setUp() {
        super.setUp()
        authManager = AuthManager()
    }

    func test_ログインが成功すること() async {

        let mailAdress = "test@testmail.com"
        let password = "000000"
        var isSuccess = Bool()

        await authManager.login(email: mailAdress, password: password, complition: { isLoginSuccess, message in
            isSuccess = isLoginSuccess
        })

        XCTAssertEqual(isSuccess, true)
    }

    func test_ログインのエラーが返ってくること_パスワードミス() async {
        let mailAdress = "test@testmail.com"
        let password = "111111"
        var isSuccess = Bool()

        await authManager.login(email: mailAdress, password: password, complition: { isLoginSuccess, message in
            isSuccess = isLoginSuccess
        })

        XCTAssertEqual(isSuccess, false)
    }

    func test_ログインのエラーが返ってくること_メールアドレスミス() async {

        let mailAdress = "test.miss@testmail.com"
        let password = "000000"
        var isSuccess = Bool()

        await authManager.login(email: mailAdress, password: password, complition: { isLoginSuccess, message in
            isSuccess = isLoginSuccess
        })


        XCTAssertEqual(isSuccess, false)
    }

    func test_ログインのエラーが返ってくること_パスワード＆メールアドレスミス() async {

        let mailAdress = "test.miss@testmail.com"
        let password = "111111"
        var isSuccess = Bool()

        await authManager.login(email: mailAdress, password: password, complition: { isLoginSuccess, message in
            isSuccess = isLoginSuccess
        })

        XCTAssertEqual(isSuccess, false)
    }

}
