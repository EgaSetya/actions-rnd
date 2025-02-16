//
//  MemoryService.swift
//  Bythen
//
//  Created by erlina ng on 10/10/24.
//

import Foundation

protocol MemoryServiceProtocol {
    func getMemories(buildID: Int64) async throws -> MemoryResponse
    
    func updateMemories(buildID: Int64, memoryID: Int64, memory: String) async throws
    
    func deleteMemories(buildID: Int64, memoryID: Int64) async throws
}

class MemoryService: BythenApi, MemoryServiceProtocol {
    private let kMemories = "/v1/memories"
    
    override init() {
        super.init(servicePath: AppConstants.kMSChatbotName)
    }
    
    func getMemories(buildID: Int64) async throws -> MemoryResponse {
        let url = urlForEndpoint("\(kMemories)/\(buildID)")
        return try await Http.get(url, headers: try authHeaders())
    }
    
    func updateMemories(buildID: Int64, memoryID: Int64, memory: String) async throws {
        let url = urlForEndpoint("\(kMemories)/\(buildID)/\(memoryID)")
        let params: [String: Any] = ["-": 0, "memory": memory]
        let _: EmptyBody = try await Http.put(url, json: params, headers: try authHeaders())
    }
    
    func deleteMemories(buildID: Int64, memoryID: Int64) async throws {
        let url = urlForEndpoint("\(kMemories)/\(buildID)/\(memoryID)")
        let _: EmptyBody = try await Http.delete(url, headers: try authHeaders())
    }
}
