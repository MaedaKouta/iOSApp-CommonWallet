//
//  DateManager.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import Foundation

class DateManager {

    func getNowDate()  {
        let now = NSDate() // 現在日時の取得

        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    }

}
