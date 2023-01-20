//
//  LoginTests.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/20.
//

import XCTest
import FirebaseCore
@testable import CommonWallet

final class LoginTests: XCTestCase {

    private var authManager: AuthManager!

    class override func setUp() {
        super.setUp()
        FirebaseApp.configure()
    }

    override func setUp() {
        super.setUp()
        authManager = AuthManager()
    }

    func test_ログインが成功すること() {
        let expect = expectation(description: "test_ログインが成功すること")

        let mailAdress = "test@testmail.com"
        let password = "000000"
        var isSuccess = Bool()

        authManager.login(email: mailAdress, password: password, complition: { isLoginSuccess, message in
            isSuccess = isLoginSuccess
            expect.fulfill()
        })

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("expectationのタイムアウトエラー : \(error)")
            }
        }

        XCTAssertEqual(isSuccess, true)
    }

    func test_ログインのエラーが返ってくること_パスワードミス() {

        let expect = expectation(description: "test_ログインのエラーが返ってくること_パスワードミス")
        let mailAdress = "test@testmail.com"
        let password = "111111"
        var isSuccess = Bool()

        authManager.login(email: mailAdress, password: password, complition: { isLoginSuccess, message in
            isSuccess = isLoginSuccess
            expect.fulfill()
        })

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("expectationのタイムアウトエラー : \(error)")
            }
        }

        XCTAssertEqual(isSuccess, false)
    }

    func test_ログインのエラーが返ってくること_メールアドレスミス() {

        let expect = expectation(description: "test_ログインのエラーが返ってくること_メールアドレスミス")
        let mailAdress = "test.miss@testmail.com"
        let password = "000000"
        var isSuccess = Bool()

        authManager.login(email: mailAdress, password: password, complition: { isLoginSuccess, message in
            isSuccess = isLoginSuccess
            expect.fulfill()
        })

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("expectationのタイムアウトエラー : \(error)")
            }
        }

        XCTAssertEqual(isSuccess, false)
    }

    func test_ログインのエラーが返ってくること_パスワード＆メールアドレスミス() {

        let expect = expectation(description: "test_ログインのエラーが返ってくること_パスワード＆メールアドレスミス")
        let mailAdress = "test.miss@testmail.com"
        let password = "111111"
        var isSuccess = Bool()

        authManager.login(email: mailAdress, password: password, complition: { isLoginSuccess, message in
            isSuccess = isLoginSuccess
            expect.fulfill()
        })

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("expectationのタイムアウトエラー : \(error)")
            }
        }

        XCTAssertEqual(isSuccess, false)
    }

}
