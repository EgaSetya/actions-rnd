//
//  ByteBackground.swift
//  Bythen
//
//  Created by edisurata on 29/09/24.
//

import Foundation

struct ByteBackground: Codable, Identifiable {
    let id = UUID()
    
    @DefaultEmptyString var background: String = ""
    @DefaultBackgroundType var backgroundType: BackgroundType = .color
    @DefaultEmptyString var byteSymbol: String = ""
    
    enum CodingKeys: String, CodingKey {
        case background = "background"
        case backgroundType = "background_type"
        case byteSymbol = "byte_symbol"
    }
}
