//
//  FireBaseErrorType.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/21.
//

import Foundation

enum FirebaseErrorType: Error {
    case FireStore(NSError)
    case Auth(NSError)
    case other(String)
}
