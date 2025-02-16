//
//  GetBytesResponse.swift
//  Bythen
//
//  Created by edisurata on 04/09/24.
//

import Foundation

struct GetBytesResponse: Codable {
    var wallet: String = ""
    var totalAssetReady: Int64 = 0
    var bytes: [Byte] = []
    var totalByte: [String: Int] = ["pod": 0]
    
    enum CodingKeys: String, CodingKey {
        case wallet = "wallet"
        case totalAssetReady = "total_asset_ready"
        case bytes = "bytes"
        case totalByte = "total_byte"
    }
}

struct ListColorLogs: Codable {
    var colorLogs: [ByteBackgroundColor] = []
    
    enum CodingKeys: String, CodingKey {
        case colorLogs = "colors"
    }
}
