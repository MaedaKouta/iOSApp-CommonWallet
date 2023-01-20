//
//  CreateUserTests.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/20.
//

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

    // 毎回アカウント登録するわけにはいかないのでコメントアウト
    func test_アカウント登録が成功すること() {
        let expect = expectation(description: "test_アカウント登録が成功すること")

        let mailAdress = "test@testmail.com"
        let password = "000000"
        let name = "test"
        var isSuccess = Bool()

        authManager.createUser(email: mailAdress, password: password, name: name, complition: { isCreateUserSuccess, message in
            isSuccess = isCreateUserSuccess
            expect.fulfill()
        })

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("expectationのタイムアウトエラー : \(error)")
            }
        }

        XCTAssertEqual(isSuccess, true)
    }

    func test_アカウント登録のエラーが返ってくること_既にアカウント存在() {
        let expect = expectation(description: "test_アカウント登録のエラーが返ってくること_既にアカウント存在")

        let mailAdress = "test@testmail.com"
        let password = "000000"
        let name = "test"
        var isSuccess = Bool()

        authManager.createUser(email: mailAdress, password: password, name: name, complition: { isCreateUserSuccess, message in
            isSuccess = isCreateUserSuccess
            expect.fulfill()
        })

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("expectationのタイムアウトエラー : \(error)")
            }
        }

        XCTAssertEqual(isSuccess, false)
    }

    func test_アカウント登録のエラーが返ってくること_アドレス形式ミス() {

        let expect = expectation(description: "test_ログインのエラーが返ってくること_アドレス形式ミス")
        let mailAdress = "aaa"
        let password = "000000"
        let name = "test"
        var isSuccess = Bool()

        authManager.createUser(email: mailAdress, password: password, name: name, complition: { isCreateUserSuccess, message in
            isSuccess = isCreateUserSuccess
            expect.fulfill()
        })

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("expectationのタイムアウトエラー : \(error)")
            }
        }

        XCTAssertEqual(isSuccess, false)
    }

    func test_アカウント登録のエラーが返ってくること_パスワード短い() {

        let expect = expectation(description: "test_アカウント登録のエラーが返ってくること_パスワード短い")

        let mailAdress = "test@testmail.com"
        let password = "0"
        let name = "test"
        var isSuccess = Bool()

        authManager.createUser(email: mailAdress, password: password, name: name, complition: { isCreateUserSuccess, message in
            isSuccess = isCreateUserSuccess
            expect.fulfill()
        })

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("expectationのタイムアウトエラー : \(error)")
            }
        }

        XCTAssertEqual(isSuccess, false)
    }

    func test_アカウント登録のエラーが返ってくること_名前が空() {

        let expect = expectation(description: "test_アカウント登録のエラーが返ってくること_名前がnull")
        let mailAdress = "test@testmail.com"
        let password = "000000"
        let name = ""
        var isSuccess = Bool()

        authManager.createUser(email: mailAdress, password: password, name: name, complition: { isCreateUserSuccess, message in
            isSuccess = isCreateUserSuccess
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
