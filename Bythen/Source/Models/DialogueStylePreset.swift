//
//  DialogueStylePreset.swift
//  Bythen
//
//  Created by edisurata on 20/10/24.
//

import Foundation

struct DialogueStylePreset: Codable, Identifiable {
    let id = UUID()
    
    var label: String
    var value: String
    
    enum CodingKeys: String, CodingKey {
        case label = "label"
        case value = "value"
    }
}
