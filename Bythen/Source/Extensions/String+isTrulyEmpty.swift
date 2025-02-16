//
//  String+isTrulyEmpty.swift
//  Bythen
//
//  Created by Ega Setya on 06/12/24.
//

extension String {
    /// To check if string is truly empty.
    /// Whether its `nil` or `empty string`
    var isTrulyEmpty: Bool {
        let text = self.trimmingCharacters(in: .whitespaces)
        
        return text.isEmpty || text == ""
    }
}
