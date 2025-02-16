//
//  TranscriptResponse.swift
//  Bythen
//
//  Created by edisurata on 17/09/24.
//

import Foundation

struct TranscriptResponse: Codable {
    var text: String = ""
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
    }
}

struct GetVoicesResponse: Codable {
    var voices: [Voice] = []
    
    enum CodingKeys: String, CodingKey {
        case voices = "voices"
    }
}
