//
//  ByteDescriptionParams.swift
//  Bythen
//
//  Created by Darindra R on 22/10/24.
//

struct ByteDescriptionParams: Codable {
    let messages: [ByteDescriptionChat]
}

struct ByteDescriptionChat: Codable {
    let content: String
    let role: String
}
