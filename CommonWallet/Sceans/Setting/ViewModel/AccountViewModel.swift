//
//  AccountViewModel.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/02.
//

import Foundation
import FirebaseAuth
import SwiftUI

class AccountViewModel: ObservableObject {

    @Published var userName = ""
    @Published var userEmail = ""
    @Published var myIconImage: UIImage

    private var userDefaultsManager = UserDefaultsManager()
    private var storageManager = StorageManager()

    init() {
        userName = userDefaultsManager.getUser()?.name ?? ""
        userEmail = userDefaultsManager.getUser()?.email ?? ""
        if let accountImageData =  userDefaultsManager.getMyIconImageData(),
           let accountImage = UIImage(data: accountImageData) {
            myIconImage = accountImage
        } else {
            myIconImage = UIImage(named: "icon-not-found")!
        }
    }

    func uploadIconImage(image: UIImage, completion: @escaping(Bool, Error?) -> Void) {
        storageManager.upload(image: image, completion: { path, imageData, error in
            if error != nil {
                completion(false, error)
                return
            }

            guard let path = path,
                  let imageData = imageData,
                  let image = UIImage(data: imageData) else {
                completion(false, NSError())
                return
            }
            self.userDefaultsManager.setMyIcon(path: path, imageData: imageData)
            self.myIconImage = image
            completion(true, nil)
        })
    }

}
