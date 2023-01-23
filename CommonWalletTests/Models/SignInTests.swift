//
//  LoginTests.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/20.
//

import XCTest
import FirebaseCore
import FirebaseAuth
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

        let mailAdress = "test.unittest@testmail.com"
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

}
