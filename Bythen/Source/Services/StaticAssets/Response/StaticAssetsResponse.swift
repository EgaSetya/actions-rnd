//
//  GetStickersResponse.swift
//  Bythen
//
//  Created by edisurata on 10/09/24.
//

import Foundation
import SwiftUI

struct GetStickersResponse: Codable {
    var enabled: Bool = false
    var stickers: [Sticker] = []
    var animation: StickerAnimation = .init()

    enum CodingKeys: String, CodingKey {
        case stickers
        case animation
    }
}

struct GetVoiceTagsResponse: Codable {
    var base: [VoiceTag] = []
    var accents: [VoiceTag] = []
    var age: [VoiceTag] = []

    enum CodingKeys: String, CodingKey {
        case base
        case accents
        case age
    }
}

struct GetPersonalitiesResponse: Codable {
    var bytePersonalities: [BytePersonality]
    enum CodingKeys: String, CodingKey {
        case bytePersonalities = "data"
    }
}

struct BytePersonality: Codable, Hashable, Identifiable {
    var id: String {
        minLabel
    }

    var currentValue: Int64 = 1
    var currentValueDouble: Double {
        get { return Double(currentValue) }
        set { currentValue = Int64(newValue) }
    }

    var minLabel: String
    var minValue: Int
    var maxLabel: String
    var maxValue: Int
    var rangeSlide: ClosedRange<Double> {
        get { return Double(minValue - 1) ... Double(maxValue) }
        set {}
    }

    enum CodingKeys: String, CodingKey {
        case minLabel = "min_label"
        case minValue = "min_value"
        case maxLabel = "max_label"
        case maxValue = "max_value"
    }
}

struct HiveRankRulesResponse: Codable {
    let commisions: [String: HiveRankCommision]
    let rules: [String: HiveRankRule]
    let maxSlot: Int

    enum CodingKeys: String, CodingKey {
        case commisions
        case rules
        case maxSlot = "max_slot"
    }
}

struct HiveRankCommision: Codable {
    let directCommision, passupCommision, pairingCommision, frameURL, generalComission: String
    let showStar: Bool

    enum CodingKeys: String, CodingKey {
        case directCommision = "direct_commision"
        case passupCommision = "passup_commision"
        case pairingCommision = "pairing_commision"
        case generalComission = "general_comission"
        case frameURL = "frame_url"
        case showStar = "show_star"
    }
}

struct HiveRankRule: Codable {
    let beaconPoint: Int
    let iconURL: String
    let showStar: Bool
    let tierName: String
    let bonusCaption: String

    enum CodingKeys: String, CodingKey {
        case beaconPoint = "beacon_point"
        case iconURL = "icon_url"
        case showStar = "show_star"
        case tierName = "tier_name"
        case bonusCaption = "bonus_caption"
    }
}

struct HiveOnboardingResponse: Codable {
    let videoURL: String
    let telegramGroup: String
    
    enum CodingKeys: String, CodingKey {
        case videoURL = "video_url"
        case telegramGroup = "telegram_group"
    }
}
