//
//  HiveExpiredPoints.swift
//  Bythen
//
//  Created by Ega Setya on 31/01/25.
//

struct HiveExpiredPoints: Codable {
    let totalUnlockedPoint: Int
    let expiredAt: String
    @DefaultEmptyString var message: String

    enum CodingKeys: String, CodingKey {
        case totalUnlockedPoint = "total_unlocked_point"
        case expiredAt = "expired_at"
        case message
    }
}
