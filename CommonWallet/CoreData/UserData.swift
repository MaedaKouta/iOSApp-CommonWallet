////
////  UserData.swift
////  CommonWallet
////
//
//import Foundation
//
//final public class UserData: ObservableObject {
//
//    private var authManager = AuthManager()
//    private var shareNumberManager = ShareNumberManager()
//    private var fireStoreTransactionManager = FireStoreTransactionManager()
//    private var fireStoreUserManager = FireStoreUserManager()
//    private var fireStorePartnerManager = FireStorePartnerManager()
//    private var storageManager = StorageManager()
//    private var userDefaultsManager = UserDefaultsManager()
//
//    // ここでUserInfoをfetchする
//    // addSnapListernerだから、更新されるたびに自動でUserDefaultsが更新される
//    func realtimeFetchUserInfo() async {
//        guard let myUserId = userDefaultsManager.getUser()?.id else { return }
//        self.fireStoreUserManager.realtimeFetchInfo(userId: myUserId, completion: { [weak self] user, error in
//            if let error = error {
//                print(error)
//                return
//            }
//            guard let user = user else { return }
//            self?.userDefaultsManager.setUser(user: user)
//        })
//    }
//
//}
