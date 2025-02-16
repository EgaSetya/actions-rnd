//
//  StickerAnimation.swift
//  Bythen
//
//  Created by edisurata on 10/09/24.
//

import Foundation

struct Sticker: Codable, Identifiable {
    let id = UUID()
    var imageUrl: String = ""
    var leading: Double = 0
    var trailing: Double = 0
    var top: Double = 0
    var bottom: Double = 0
    var isAnimated: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case leading = "leading"
        case trailing = "trailing"
        case top = "top"
        case bottom = "bottom"
    }
}

struct StickerAnimation: Codable {
    var enabled: Bool = false
    var duration: Double = 0
    var offset: Double = 0
    
    enum CodingKeys: String, CodingKey {
        case enabled = "enabled"
        case duration = "duration"
        case offset = "offset"
    }
}
