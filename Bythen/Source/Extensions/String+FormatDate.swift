//
//  String+FormatDate.swift
//  Bythen
//
//  Created by erlina ng on 03/01/25.
//

import Foundation

extension String {
    func convertToDateFormat(from inputFormat: String = "yyyy-MM-dd HH:mm:ss", to outputFormat: String = "dd MMM yyyy") -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent parsing
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        
        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        } else {
            return "" // Return nil if the input string is invalid
        }
    }
}
