//
//  Personality.swift
//  Bythen
//
//  Created by edisurata on 04/09/24.
//

import Foundation

struct Personality: Codable {
    var name: String = ""
    var value: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case value = "value"
    }
}
