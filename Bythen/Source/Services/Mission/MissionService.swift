//
//  MissionService.swift
//  Bythen
//
//  Created by Darul Firmansyah on 06/01/25.
//

import Foundation

protocol MissionServiceProtocol {
    func getAvailableMissions() async throws -> MissionsResponse
    func getCompletedMissions(page: Int, limit: Int) async throws -> MissionsResponse
    func postMissionObjectives(mission: MissionDetailViewModel) async throws -> MissionObjectiveResponse
}

class MissionService: BythenApi, MissionServiceProtocol {
    
    enum Endpoint: ApiEndpointProtocol {
        case availableMissions
        case completedMissions
        case missionObjectives
        
        var path: String {
            switch self {
            case .availableMissions: "/v1/missions/available"
            case .completedMissions: "/v1/missions/completed"
            case .missionObjectives: "/v1/accounts/objectives"
            }
        }
    }
    
    override init() {
        super.init(servicePath: AppConstants.kMSMissionName)
    }
    
    func getAvailableMissions() async throws -> MissionsResponse {
        let url = fullUrl(Endpoint.availableMissions)
        let header = try authHeaders()
        return try await Http.asyncGet(url, parameters: ["limit": 1000], headers: header)
    }
    
    func getCompletedMissions(page: Int, limit: Int) async throws -> MissionsResponse {
        let url = fullUrl(Endpoint.completedMissions)
        let header = try authHeaders()
        return try await Http.asyncGet(url, parameters: ["page": page, "limit": limit], headers: header)
    }
    
    func postMissionObjectives(mission: MissionDetailViewModel) async throws -> MissionObjectiveResponse {
        let parameters: [String: Any] = ["mission_id": mission.missionId, "mission_objective_ids": mission.missionObjective.map({ $0.id
        })]
        
        let url = fullUrl(Endpoint.missionObjectives)
        let header = try authHeaders()
        return try await Http.post(url, json: parameters, headers: header)
    }
}
