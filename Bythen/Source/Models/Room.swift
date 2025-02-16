//
//  Room.swift
//  Bythen
//
//  Created by edisurata on 20/09/24.
//

import Foundation
import BetterCodable

struct Room: Codable, Identifiable {
    var id = UUID()
    
    @DefaultZeroInt64 var roomID: Int64 = 0
    @DefaultEmptyString var title: String = ""
    @DefaultEmptyString var summary: String = ""
    @DefaultFalse var isPrimary: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case roomID = "id"
        case title = "title"
        case summary = "summary"
        case isPrimary = "is_primary"
    }
}
