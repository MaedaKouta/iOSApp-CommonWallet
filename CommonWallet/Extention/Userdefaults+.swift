//
//  Userdefaults.swift
//  CommonWallet
//

import Foundation
import SwiftUI

extension UserDefaults {

    // 保存したいUIImage, 保存するUserDefaults, Keyを取得
    func setUIImageToData(image: UIImage, forKey: String) {
        let nsdata = image.pngData()
        self.set(nsdata, forKey: forKey)
    }

    // 参照するUserDefaults, Keyを取得, UIImageを返す
    func image(forKey: String) -> UIImage {
        let data = self.data(forKey: forKey)
        let returnImage = UIImage(data: data!)
        return returnImage!
    }

}
