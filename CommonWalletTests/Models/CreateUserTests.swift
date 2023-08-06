//
//  CreateUserTests.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/20.
//

/*
 　端末の情報も必要なので、実際のアカウント登録のテストは出来ない？
 */

import XCTest
import FirebaseCore
@testable import CommonWallet

final class CreateUserTests: XCTestCase {

    private var authManager: AuthManager!

    class override func setUp() {
        super.setUp()
        FirebaseApp.configure()
    }

    override func setUp() {
        super.setUp()
        authManager = AuthManager()
    }

    func test_アカウント登録のエラーが返ってくること_既にアカウント存在() async {

        let mailAdress = "test.unittest@testmail.com"
        let password = "000000"
        let name = "test"
        var isSuccess = Bool()

        do {
            try await authManager.createUser(email: mailAdress, password: password, name: name)
            isSuccess = true
        } catch {
            isSuccess = false
        }

        XCTAssertEqual(isSuccess, false)
    }

    func test_アカウント登録のエラーが返ってくること_アドレス形式ミス() async {
        let mailAdress = "aaa"
        let password = "000000"
        let name = "test"
        var isSuccess = Bool()

        do {
            try await authManager.createUser(email: mailAdress, password: password, name: name)
            isSuccess = true
        } catch {
            isSuccess = false
        }

        XCTAssertEqual(isSuccess, false)
    }

    func test_アカウント登録のエラーが返ってくること_パスワード短い() async {

        let mailAdress = "test.unittest@testmail.com"
        let password = "0"
        let name = "test"
        var isSuccess = Bool()

        do {
            try await authManager.createUser(email: mailAdress, password: password, name: name)
            isSuccess = true
        } catch {
            isSuccess = false
        }

        XCTAssertEqual(isSuccess, false)
    }

}
