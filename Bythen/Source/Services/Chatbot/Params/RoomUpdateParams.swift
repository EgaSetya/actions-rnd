//
//  RoomUpdateParams.swift
//  Bythen
//
//  Created by edisurata on 22/09/24.
//

import Foundation

struct RoomUpdateParams: Codable {
    var title: String = ""
    
    enum CodingKeys: String, CodingKey {
    case title = "title"
    }
}
