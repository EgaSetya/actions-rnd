//
//  RoomService.swift
//  Bythen
//
//  Created by edisurata on 20/09/24.
//

import Foundation

protocol RoomServiceProtocol {
    func getRooms(buildID: Int64) async throws -> GetRoomsResponse
    func updateRooms(buildID: Int64, roomID: Int64, params: RoomUpdateParams) async throws
    func deleteRooms(buildID: Int64, roomID: Int64) async throws
    func createRooms(buildID: Int64, title: String) async throws -> Int64
}

class RoomService: BythenApi, RoomServiceProtocol {
    private let kGetRoomsEndpoint = "/v1/rooms"
    
    override init() {
        super.init(servicePath: AppConstants.kMSChatbotName)
    }
    
    private func urlUpdateRoomEndpoint(buildID: Int64, roomID: Int64) -> String {
        return urlForEndpoint("/v1/rooms/\(buildID)/\(roomID)")
    }
    
    private func urlDeleteRoomEndpoint(buildID: Int64, roomID: Int64) -> String {
        return urlForEndpoint("/v1/rooms/\(buildID)/\(roomID)")
    }
    
    private func urlCreateRoomEndpoint(buildID: Int64) -> String {
        return urlForEndpoint("/v1/rooms/\(buildID)")
    }
    
    func getRooms(buildID: Int64) async throws -> GetRoomsResponse {
        let url = urlForEndpoint(kGetRoomsEndpoint)
        let resp: GetRoomsResponse = try await Http.get(url, parameters: ["build_id": buildID], headers: try authHeaders())
        
        return resp
    }
    
    func updateRooms(buildID: Int64, roomID: Int64, params: RoomUpdateParams) async throws {
        let url = urlUpdateRoomEndpoint(buildID: buildID, roomID: roomID)
        let _: EmptyBody = try await Http.put(url, json: params, headers: try authHeaders())
    }
    
    func deleteRooms(buildID: Int64, roomID: Int64) async throws {
        let url = urlDeleteRoomEndpoint(buildID: buildID, roomID: roomID)
        let _: EmptyBody = try await Http.delete(url, headers: try authHeaders())
    }
    
    func createRooms(buildID: Int64, title: String) async throws -> Int64 {
        let url = urlCreateRoomEndpoint(buildID: buildID)
        let resp: createRoomResponse = try await Http.post(url, json: ["title": title], headers: try authHeaders())
        return resp.roomID
    }
}
