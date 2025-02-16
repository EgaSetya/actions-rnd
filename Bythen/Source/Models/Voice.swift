//
//  Voice.swift
//  Bythen
//
//  Created by edisurata on 14/10/24.
//

import Foundation

struct Voice: Codable {
    var voiceID: Int64
    var slug: String
    var provider: String
    var displayName: String
    var voiceSampleUrl: String
    
    enum CodingKeys: String, CodingKey {
        case voiceID = "id"
        case slug = "slug"
        case provider = "provider"
        case displayName = "display_name"
        case voiceSampleUrl = "voice_sample_url"
    }
}
