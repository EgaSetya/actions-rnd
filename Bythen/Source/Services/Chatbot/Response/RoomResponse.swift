//
//  ResponseBody.swift
//  Bythen
//
//  Created by edisurata on 20/09/24.
//

import Foundation

struct GetRoomsResponse: Codable {
    var rooms: [Room]
    
    enum CodingKeys: String, CodingKey {
        case rooms = "rooms"
    }
}

struct createRoomResponse: Codable {
    var roomID: Int64
    
    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
    }
}
