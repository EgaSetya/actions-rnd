//
//  String+Validation.swift
//  Bythen
//
//  Created by Ega Setya on 16/12/24.
//

import Foundation

extension String {
    var isEmailValid: Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
}
