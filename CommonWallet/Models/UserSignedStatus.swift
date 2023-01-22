//
//  UserStatusUtil.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/22.
//

import Foundation
import Firebase
import FirebaseAuth

class UserSignedStatus {

    static var isSignedIn: Bool {
        get{
            if let uid = Auth.auth().currentUser?.uid {
                print("ログイン済みのアカウントが起動/uid:",uid)
                return true
            } else {
                return false
            }
        }
    }

}
