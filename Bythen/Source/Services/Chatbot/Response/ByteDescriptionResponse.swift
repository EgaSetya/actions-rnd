//
//  ByteDescriptionResponse.swift
//  Bythen
//
//  Created by Darindra R on 22/10/24.
//

struct ByteDescriptionResponse: Codable {
    let question: String
    let description: String
    let isFinished: Bool
    let content: String

    enum CodingKeys: String, CodingKey {
        case question
        case description
        case isFinished = "is_finished"
        case content
    }
}
