//
//  BytesMediaResponse.swift
//  Bythen
//
//  Created by edisurata on 29/09/24.
//

import Foundation

struct ListMediaBytesBackgrounds: Codable {
    var backgrounds: [ByteBackground]
    
    enum CodingKeys: String, CodingKey {
        case backgrounds = "assets"
    }
}

struct ListMediaBytesBackgroundImages: Codable {
    var backgroundImages: [ByteBackgroundImage]
    
    enum CodingKeys: String, CodingKey {
        case backgroundImages = "background_images"
    }
}

struct UploadMediaBytesBackgorundImageResponse: Codable {
    var fileUrl: String
    
    enum CodingKeys: String, CodingKey {
        case fileUrl = "file_url"
    }
}
