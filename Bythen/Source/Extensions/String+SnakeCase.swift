//
//  String+SnakeCase.swift
//  Bythen
//
//  Created by Ega Setya on 15/01/25.
//

import Foundation

extension String {
  func snakeCased() -> String? {
    let pattern = "([a-z0-9])([A-Z])"

    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(location: 0, length: self.count)
    return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
  }
}
