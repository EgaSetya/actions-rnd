//
//  Untitled.swift
//  Bythen
//
//  Created by Darindra R on 07/10/24.
//

import BetterCodable
import Foundation

struct ChatHistoryResponse: Codable {
    let messages: [ChatHistory]
}

struct ChatHistory: Codable, Equatable {
    enum Role: String, Codable, Equatable {
        case assistant
        case user
        case initial
    }

    var id: Int64
    var content: String
    var role: Role
    var isBad: Bool
    var isProcessing: Bool
    var isMemoryAdded: Bool
    var searchData: [ChatDataURL]
    var remoteContent: String?
    let fileURL: String?
    let attachment: Attachment?

    enum CodingKeys: String, CodingKey {
        case id
        case content
        case role
        case isBad = "is_bad"
        case searchData = "search_data"
        case fileURL = "file_url"
    }

    init(
        id: Int64,
        content: String,
        role: Role,
        isBad: Bool = false,
        isProcessing: Bool = false,
        isMemoryAdded: Bool = false,
        searchData: [ChatDataURL] = [],
        fileURL: String? = nil,
        attachment: Attachment? = nil,
        remoteContent: String? = nil
    ) {
        self.id = id
        self.content = content
        self.role = role
        self.isBad = isBad
        self.isProcessing = isProcessing
        self.isMemoryAdded = isMemoryAdded
        self.searchData = searchData
        self.fileURL = fileURL
        self.attachment = attachment
        self.remoteContent = remoteContent
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int64.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content).replacingOccurrences(of: "\\n", with: "\n")
        role = try container.decode(ChatHistory.Role.self, forKey: .role)
        isBad = try container.decodeIfPresent(Bool.self, forKey: .isBad) ?? false
        searchData = try container.decodeIfPresent([ChatDataURL].self, forKey: .searchData) ?? []
        fileURL = try container.decodeIfPresent(String.self, forKey: .fileURL)
        attachment = nil
        isProcessing = false
        isMemoryAdded = false
        remoteContent = content
    }
}
