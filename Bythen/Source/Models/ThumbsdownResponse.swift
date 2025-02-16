//
//  ThumbsdownResponse.swift
//  Bythen
//
//  Created by Darindra R on 06/10/24.
//

import Foundation

struct ThumbsdownResponse: Codable {
    let isFeedbackBad: Bool

    enum CodingKeys: String, CodingKey {
        case isFeedbackBad = "is_feedback_bad"
    }
}
