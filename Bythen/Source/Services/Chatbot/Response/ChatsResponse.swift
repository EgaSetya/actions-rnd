//
//  ChatResponse.swift
//  Bythen
//
//  Created by edisurata on 26/09/24.
//

import Foundation

struct ChatSummaryResponse: Codable {
    var title: String
    var summary: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case summary = "summary"
    }
}
