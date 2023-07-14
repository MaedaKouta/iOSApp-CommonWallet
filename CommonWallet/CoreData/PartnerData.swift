////
////  PartnerData.swift
////  CommonWallet
////
//
//import Foundation
//
//final public class PartnerData: ObservableObject {
//
//    private var authManager = AuthManager()
//    private var shareNumberManager = ShareNumberManager()
//    private var fireStoreTransactionManager = FireStoreTransactionManager()
//    private var fireStoreUserManager = FireStoreUserManager()
//    private var fireStorePartnerManager = FireStorePartnerManager()
//    private var storageManager = StorageManager()
//    private var userDefaultsManager = UserDefaultsManager()
//
//    func realtimeFetchPartnerInfo() async {
//        guard let myUserId = userDefaultsManager.getUser()?.id else { return }
//        fireStorePartnerManager.realtimeFetchInfo(myUserId: myUserId, completion: { [weak self] partner, error in
//            if let error = error {
//                print(error)
//                return
//            }
//            guard let partner = partner else { return }
//            self?.userDefaultsManager.setPartner(partner: partner)
//        })
//    }
//}
