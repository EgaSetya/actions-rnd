//
//  HiveRank.swift
//  Bythen
//
//  Created by erlina ng on 08/12/24.
//

struct HiveRank: Codable {
    var activeStatus: Bool = false ///Rank Status
    var beaconPoints: Int = 0
    var tier: Int = 0 /// User's rank
    var tierName: String = "" /// User's rank name
    var isTrial: Bool = false
    var trialCountdown: Int = 0

    enum CodingKeys: String, CodingKey {
        case activeStatus = "active_status"
        case beaconPoints = "beacon_points"
        case tier
        case tierName = "tier_name"
        case isTrial = "is_trial"
        case trialCountdown = "trial_countdown"
    }
}
