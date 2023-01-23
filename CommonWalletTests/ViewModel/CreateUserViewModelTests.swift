//
//  CreateUserViewModelTests.swift
//  CommonWalletTests
//
//  Created by 前田航汰 on 2023/01/21.
//

import XCTest
import FirebaseCore
import FirebaseAuth
@testable import CommonWallet

final class CreateUserViewModelTests: XCTestCase {

    private var createUserViewModel: CreateUserViewModel!

    class override func setUp() {
        super.setUp()
        FirebaseApp.configure()
    }

    override func setUp() {
        super.setUp()
        createUserViewModel = CreateUserViewModel()
    }

    // MARK: - CreateUser関数
    func test_CreateUserがメール形式ミスで失敗してメッセージが返ってくること() async {
        let mailAdress = "test"
        let password = "000000"
        let name = "テスト"

        await createUserViewModel.createUser(email: mailAdress, password: password, name: name, complition: { isSuccess, message in
            XCTAssertEqual(isSuccess, false)
            XCTAssertEqual(message, "メールアドレスの形式が違います。")
        })
    }

    func test_CreateUserが既に使われてるメールアドレスで失敗してメッセージが返ってくること() async {
        let mailAdress = "test.unittest@testmail.com"
        let password = "000000"
        let name = "test"

        await createUserViewModel.createUser(email: mailAdress, password: password, name: name, complition: { isSuccess, message in
            XCTAssertEqual(isSuccess, false)
            XCTAssertEqual(message, "このメールアドレスはすでに使われています。")
        })
    }

    func test_CreateUserがパスワード脆弱で失敗してメッセージが返ってくること() async {
        let mailAdress = "test.unittest@testmail.com"
        let password = "0"
        let name = "test"

        await createUserViewModel.createUser(email: mailAdress, password: password, name: name, complition: { isSuccess, message in
            XCTAssertEqual(isSuccess, false)
            XCTAssertEqual(message, "パスワードが弱すぎます。")
        })
    }


}
