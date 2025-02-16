//
//  ByteResponse.swift
//  Bythen
//
//  Created by edisurata on 25/09/24.
//

import Foundation

struct BuildResponse: Codable {
    var build: ByteBuild
    var roomID: Int64
    
    enum CodingKeys: String, CodingKey {
        case build = "build"
        case roomID = "room_id"
    }
}
