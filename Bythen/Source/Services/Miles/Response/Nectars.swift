//
//  Nectars.swift
//  Bythen
//
//  Created by Ega Setya on 03/02/25.
//

struct Nectars: Codable {
    let nectars: [Nectar]
    let pagination: Pagination?
}

// MARK: - Nectar
struct Nectar: Codable {
    let accountID, point: Int
    let source: String
    var sourceTitle: String?
    var createdAt: String?
    var allocatedAt: String?

    enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case point, source
        case createdAt = "created_at"
        case allocatedAt = "allocated_at"
        case sourceTitle = "source_title"
    }
}
