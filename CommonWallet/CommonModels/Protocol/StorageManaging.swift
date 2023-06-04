//
//  StorageManaging.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/06/04.
//

import Foundation
import FirebaseStorage
import UIKit

protocol StorageManaging {
    func upload(image: UIImage, completion: @escaping(String?, Data?, StorageError?) -> Void)
    func download(path: String, completion: @escaping(Data?, Error?) -> Void)
    func deleteImage(path: String)
}
