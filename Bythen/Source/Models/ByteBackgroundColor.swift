//
//  ByteBackgroundColor.swift
//  Bythen
//
//  Created by edisurata on 10/10/24.
//

import Foundation

class ByteBackgroundColor: Codable {
    var colorID: Int64 = 0
    var color: String = "#000000"
    
    enum CodingKeys: String, CodingKey {
        case colorID = "id"
        case color = "color"
    }
}
