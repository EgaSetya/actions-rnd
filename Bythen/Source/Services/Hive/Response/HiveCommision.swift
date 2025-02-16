//
//  HiveCommision.swift
//  Bythen
//
//  Created by erlina ng on 12/12/24.
//

import Foundation

struct HiveCommision: Codable {
    internal var aggregate: HiveSummary?
    internal var page: Int
    internal var hivePoints: [HivePoint]
    internal var totalData: Int
    internal var totalPage: Int
    
    enum CodingKeys: String, CodingKey {
        case aggregate
        case page
        case hivePoints = "points"
        case totalData = "total_data"
        case totalPage = "total_page"
    }
}

struct HiveSummary: Codable {
    internal var totalLockedPoint: Int /// lock honey
    internal var totalLockedPointUSD: String
    internal var totalPoint: Int /// life time rewards
    internal var totalPointUSD: String
    internal var totalUnlockedPoint: Int /// honey
    internal var totalUnlockedPointUSD: String
    
    enum CodingKeys: String, CodingKey {
        case totalLockedPoint = "total_locked_point"
        case totalLockedPointUSD = "total_locked_point_usd"
        case totalPoint = "total_point"
        case totalPointUSD = "total_point_usd"
        case totalUnlockedPoint = "total_unlocked_point"
        case totalUnlockedPointUSD = "total_unlocked_point_usd"
    }
}

struct HivePoint: Codable, Identifiable {
    let id = UUID()
    internal var createdAt: String
    internal var lockPoint: Int
    internal var rewardType: String
    internal var rewardTypeTitle: String
    internal var sourceUsername: String
    internal var totalPoint: Int
    internal var totalPointUSD: String
    internal var unlockedPoint: Int

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case lockPoint = "locked_point"
        case rewardType = "reward_type"
        case rewardTypeTitle = "reward_type_title"
        case sourceUsername = "source_username"
        case totalPoint = "total_point"
        case totalPointUSD = "total_point_usd"
        case unlockedPoint = "unlocked_point"
    }
}
