//
//  ByteData.swift
//  Bythen
//
//  Created by edisurata on 19/09/24.
//

import Foundation
import BetterCodable

enum ByteColorMode: String, Codable {
    case dark = "dark"
    case light = "light"
}

struct ByteData: Codable, Identifiable {
    let id = UUID()
    @DefaultZeroInt64 var byteID: Int64 = 0
    @DefaultEmptyString var byteSymbol: String = ""
    @DefaultEmptyString var traits: String = ""
    @DefaultEmptyString var originalTokenSymbol: String = ""
    @DefaultZeroInt64 var originalTokenId: Int64 = 0
    @DefaultFalse var isTrial: Bool = false
    @DefaultEmptyString var byteGifImage: String = ""
    @DefaultFalse var isOriginalTokenValid: Bool = false
    @DefaultEmptyString var backgroundColor: String = ""
    @DefaultByteColorMode var colorMode: ByteColorMode = .light
    @DefaultByteImage var byteImage: ByteImage = ByteImage()
    @DefaultFalse var isAssetReady: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case byteID = "byte_id"
        case byteSymbol = "byte_symbol"
        case traits = "traits"
        case originalTokenSymbol = "original_token_symbol"
        case originalTokenId = "original_token_id"
        case isTrial = "is_trial"
        case byteGifImage = "byte_gif_image"
        case byteImage = "byte_image"
        case isOriginalTokenValid = "is_original_token_valid"
        case backgroundColor = "background_color"
        case colorMode = "color_mode"
        case isAssetReady = "is_asset_ready"
    }
    
    init() {
        
    }
}
