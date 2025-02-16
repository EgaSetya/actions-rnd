//
//  Memory.swift
//  Bythen
//
//  Created by erlina ng on 9/10/24.
//

struct Memory: Codable, Hashable {
    internal var accountId: Int
    internal var buildId: Int64
    internal var chatId: Int
    internal var id: Int64
    internal var name: String
    
    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case buildId = "build_id"
        case chatId = "chat_id"
        case id
        case name = "memory"
    }
}
