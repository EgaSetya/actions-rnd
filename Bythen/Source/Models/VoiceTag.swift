//
//  VoiceTag.swift
//  Bythen
//
//  Created by edisurata on 14/10/24.
//

import Foundation

struct VoiceTag: Codable, Hashable {
    var value: String = ""
    var label: String = ""
    
    enum CodingKeys: String, CodingKey {
        case value = "value"
        case label = "label"
    }
    
    init() {}
}
