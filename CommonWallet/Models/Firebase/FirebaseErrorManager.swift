//
//  FirebaseErrorManager.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/21.
//

import Foundation
import Firebase
import FirebaseFirestore

enum FirebaseErrorType: Error {
    case FireStore(NSError)
    case Auth(NSError)
    case other(String)
}

class FirebaseErrorManager {

    func getAuthErrorMessage(_ error:Error?) -> String {
        if let error = error as NSError? {
            if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case .invalidEmail:
                    return "メールアドレスの形式が違います。"
                case .emailAlreadyInUse:
                    return "このメールアドレスはすでに使われています。"
                case .weakPassword:
                    return "パスワードが弱すぎます。"
                case .userNotFound, .wrongPassword:
                    return "メールアドレス、またはパスワードが間違っています"
                case .userDisabled:
                    return "このユーザーアカウントは無効化されています"
                case .networkError:
                    return "ネットワークエラーが発生しました。"
                default:
                    return "予期せぬエラーが発生しました。\nしばらく時間を置いてから再度お試しください。"
                }
            }
        }
        return "不明なエラー"
    }

    func getFirestoreErrorMessage(_ error:Error?) -> String {
        if let error = error as NSError? {
            if let errorCode = FirestoreErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case .alreadyExists:
                    return "既に存在しています。"
                case .cancelled:
                    return "操作はキャンセルされました。"
                case .dataLoss:
                    return "データが足りません。"
                default:
                    return  "予期せぬエラーが発生しました。\nしばらく時間を置いてから再度お試しください。"
                }
            }
        }
        return "不明なエラー"
    }

}
