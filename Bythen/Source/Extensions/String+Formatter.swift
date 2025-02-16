//
//  String+Currency.swift
//  Bythen
//
//  Created by Ega Setya on 31/01/25.
//

import Foundation

extension Double {
    var convertToUSDString: String {
        self.formatted(.currency(code: "USD"))
    }
    
    var removedTrailingZero: String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        
        return formatter.string(from: number) ?? ""
    }
}

extension String {
    func formatNumberString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.locale = Locale(identifier: "en_US")

        if let number = Double(self) {
            return formatter.string(from: NSNumber(value: number)) ?? ""
        }
        
        return ""
    }
}
