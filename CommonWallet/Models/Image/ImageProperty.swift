//
//  ImageProperty.swift
//  CommonWallet
//

import Foundation
import UIKit

struct ImageProperty {

    let imageNameProperty = ImageNameProperty()

    func getIconNotFoundData() -> Data {
        let imageData = UIImage(named: imageNameProperty.iconNotFound)?.jpegData(compressionQuality: 0.1)
        return imageData!
    }

    func getIconInitialPartnerData() -> Data {
        let imageData = UIImage(named: imageNameProperty.iconInitialPartner)?.jpegData(compressionQuality: 0.1)
        return imageData!
    }

}
