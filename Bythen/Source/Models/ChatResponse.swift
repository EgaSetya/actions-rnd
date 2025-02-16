//
//  ChatResponse.swift
//  Bythen
//
//  Created by edisurata on 18/09/24.
//

import BetterCodable
import Foundation

struct ChatResponse: Codable, Equatable {
    @DefaultZeroInt64 var chatID: Int64
    @DefaultEmptyArray var content: [String]
    @DefaultEmptyString var emotion: String
    @DefaultEmptyString var voice: String
    @DefaultEmptyString var processing: String
    @DefaultFalse var showMemoryLimit: Bool
    let dataURL: ChatDataURL?

    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case content
        case emotion
        case voice
        case processing
        case showMemoryLimit = "show_memory_limit"
        case dataURL = "url_data"
    }

    func getCombineContent() -> String {
        var combineText = ""
        for txt in content {
            combineText += txt.replacingOccurrences(of: "\\n", with: "\n")
        }
        return combineText
    }
}

struct ChatDataURL: Codable, Equatable, Hashable {
    @DefaultEmptyString var name: String
    @DefaultEmptyString var url: String
    @DefaultEmptyString var icon: String
    @DefaultEmptyString var baseURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case url
        case icon
        case baseURL = "base_url"
    }
}
