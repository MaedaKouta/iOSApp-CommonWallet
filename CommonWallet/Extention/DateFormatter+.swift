//
//  DateFormatter.swift
//  CommonWallet
//

import Foundation

enum Template: String {
    case date = "yMd"     // 2017/1/1
    case time = "Hms"     // 12:39:22
    case full = "yMdkHms" // 2017/1/1 12:39:22
    case onlyHour = "k"   // 17時
    case era = "GG"       // "西暦" (default) or "平成" (本体設定で和暦を指定している場合)
    case weekDay = "EEEE" // 日曜日
    case yearMonth = "yyyy/MM"     // 2017/1/1
}

extension DateFormatter {

    func setTemplate(_ template: Template) {
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: .current)
    }

}

