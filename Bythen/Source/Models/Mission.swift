//
//  Mission.swift
//  Bythen
//
//  Created by Darul Firmansyah on 06/01/25.
//
import SwiftUI

struct MissionsResponse: Codable {
    let missions: [Mission]
    let pagination: Pagination
}

struct MissionResponse: Codable {
    let mission: Mission
}

struct Mission: Codable {
    let id: Int
    let postId: String
    let imageURLString: String
    let content: String
    let earnedNectar: Int
    let countObjectiveFinished: Int
    let missionCountdown: Int?
    let objectives: [MissionObjective]
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageURLString = "mission_image_url"
        case content
        case earnedNectar = "earned_nectar"
        case countObjectiveFinished = "count_finished_objective"
        case missionCountdown = "mission_countdown"
        case objectives
        case postId = "post_id"
    }
}

struct MissionObjective: Codable, Identifiable, Hashable {
    let id: Int
    let missionId: Int
    let objective: String
    let iconURLString: String?
    let finishedAt: String?
    let status: String?
    let objectiveType: MissionObjectiveType
    
    enum CodingKeys: String, CodingKey {
        case id
        case missionId = "mission_id"
        case iconURLString = "icon_url"
        case objective
        case finishedAt = "finished_at"
        case status
        case objectiveType = "objective_type"
    }
}

enum MissionObjectiveType: String, Codable {
    case retweet = "twitter_retweet"
    case comment = "twitter_comment"
    case like = "twitter_like"
    
    var imageName: String {
        switch self {
        case .retweet:
            "mission_retweet"
        case .comment:
            "mission_comment"
        case .like:
            "mission_like"
        }
    }
}

struct MissionObjectiveResponse: Codable {
    let missionId: Int
    let missionObjectiveIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case missionId = "mission_id"
        case missionObjectiveIds = "mission_objective_ids"
    }
}
