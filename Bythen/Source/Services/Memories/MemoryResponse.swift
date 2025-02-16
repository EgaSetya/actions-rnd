//
//  MemoryResponse.swift
//  Bythen
//
//  Created by erlina ng on 10/10/24.
//

import Foundation

struct MemoryResponse: Codable {
    var memories: [Memory]
    
    enum CodingKeys: String, CodingKey {
        case memories
    }
}
