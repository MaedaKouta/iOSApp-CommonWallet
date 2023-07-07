//
//  StorageManaging.swift
//  CommonWallet
//

import Foundation
import FirebaseStorage
import UIKit

protocol StorageManaging {
    func upload(image: UIImage, completion: @escaping(String?, Data?, StorageError?) -> Void)
    func download(path: String) async throws -> Data
    func deleteImage(path: String)
}
