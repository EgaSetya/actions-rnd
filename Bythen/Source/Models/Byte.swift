//
//  Byte.swift
//  Bythen
//
//  Created by edisurata on 02/09/24.
//

import BetterCodable
import Foundation

struct Byte: Codable, Identifiable {
    let id = UUID()
    @DefaultZeroInt64 var buildID: Int64 = 0
    @DefaultEmptyString var name: String = ""
    @DefaultEmptyString var gender: String = ""
    @DefaultZeroInt64 var age: Int64 = 0
    @DefaultZeroInt64 var exp: Int64 = 0
    @DefaultZeroInt64 var totalMemory: Int64 = 0
    @DefaultZeroInt64 var totalKnowledge: Int64 = 0
    @DefaultEmptyString var description: String = ""
    @DefaultEmptyString var role: String = ""
    @DefaultFalse var isPrimary: Bool = false
    @DefaultEmptyString var background: String = ""
    @DefaultEmptyString var backgroundType: String = ""
    @DefaultEmptyString var lastUsed: String = ""
    @DefaultByteData var byteData: ByteData = .init()
    @DefaultEmptyDictionary var personalities: [Int: Personality] = [:]
    @DefaultEmptyString var byteName: String = ""
    @DefaultEmptyString var greetings: String = ""

    enum CodingKeys: String, CodingKey {
        case buildID = "build_id"
        case name
        case byteName = "byte_name"
        case gender
        case age
        case exp
        case totalMemory = "total_memory"
        case totalKnowledge = "total_knowledge"
        case description
        case role
        case isPrimary = "is_primary"
        case background
        case backgroundType = "background_type"
        case lastUsed = "last_used"
        case byteData = "byte_data"
        case personalities
        case greetings
    }

    init() {}
}


