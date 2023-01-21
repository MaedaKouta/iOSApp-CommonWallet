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

    // XCTAssertThrowsでtry awaitが使えないため、不自然なテストになっている。
    func test_サインインが成功すること() async {

        let mailAdress = "test@testmail.com"
        let password = "000000"
        var isSuccess = Bool()

        do {
            try await authManager.signIn(email: mailAdress, password: password)
            isSuccess = true
        } catch {
            isSuccess = false
        }

        XCTAssertEqual(isSuccess, true)
    }

    func test_サインインのエラーが返ってくること_パスワードミス() async {
        let mailAdress = "test@testmail.com"
        let password = "111111"
        var isSuccess = Bool()

        do {
            try await authManager.signIn(email: mailAdress, password: password)
            isSuccess = true
        } catch {
            isSuccess = false
        }

        XCTAssertEqual(isSuccess, false)
    }

    func test_サインインのエラーが返ってくること_メールアドレスミス() async {

        let mailAdress = "test.miss@testmail.com"
        let password = "000000"
        var isSuccess = Bool()

        do {
            try await authManager.signIn(email: mailAdress, password: password)
            isSuccess = true
        } catch {
            isSuccess = false
        }

        XCTAssertEqual(isSuccess, false)
    }

    func test_サインインのエラーが返ってくること_パスワード＆メールアドレスミス() async {

        let mailAdress = "test.miss@testmail.com"
        let password = "111111"
        var isSuccess = Bool()

        do {
            try await authManager.signIn(email: mailAdress, password: password)
            isSuccess = true
        } catch {
            isSuccess = false
        }

        XCTAssertEqual(isSuccess, false)
    }

}
