//
//  ByteImage.swift
//  Bythen
//
//  Created by edisurata on 20/09/24.
//

import Foundation

class ByteImage: Codable, Identifiable {
    @DefaultEmptyString var thumbnailUrl: String = ""
    @DefaultEmptyString var pngUrl: String = ""
    
    enum CodingKeys: String, CodingKey {
        case thumbnailUrl = "thumbnail_url"
        case pngUrl = "png_url"
    }
}
