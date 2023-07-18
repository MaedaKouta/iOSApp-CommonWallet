//
//  StorageManaging.swift
//  CommonWallet
//

import Foundation
import FirebaseStorage
import UIKit

protocol StorageManaging {
    func upload(imageData: Data, completion: @escaping(String?, StorageError?) -> Void)
    func download(path: String) async throws -> Data
    func deleteImage(path: String)
}
