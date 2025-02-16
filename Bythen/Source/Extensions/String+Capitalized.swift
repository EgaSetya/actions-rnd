//
//  String+Capitalized.swift
//  Bythen
//
//  Created by Ega Setya on 18/12/24.
//

extension StringProtocol {
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
