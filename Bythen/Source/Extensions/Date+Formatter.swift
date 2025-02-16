//
//  Date+Formatter.swift
//  Bythen
//
//  Created by edisurata on 07/11/24.
//

import Foundation


extension Date {
    static func dateFromString(_ dateStr: String, format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        if let date = dateFormatter.date(from: dateStr) {
            return date
        } else {
            return nil
        }
    }
}
