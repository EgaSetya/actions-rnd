//
//  MilesService.swift
//  Bythen
//
//  Created by erlina ng on 26/12/24.
//

import Foundation

protocol MilesServiceProtocol {
    func getNectars(page: Int, limit: Int) async throws -> Nectars
    func getNectarsCount() async throws -> NectarCount
}

class MilesService: BythenApi, MilesServiceProtocol {
    enum Endpoint: ApiEndpointProtocol {
        case nectars
        case nectarsCount
        
        var path: String {
            switch self {
            case .nectars: "/v1/nectars"
            case .nectarsCount: "/v1/nectars/count"
            }
        }
    }
    
    override init() {
        super.init(servicePath: AppConstants.ksMSMilesName)
    }
    
    func getNectars(page: Int, limit: Int) async throws -> Nectars {
        return try await Http.get(fullUrl(Endpoint.nectars), parameters: ["page": page, "limit": limit], headers: authHeaders())
    }
    
    func getNectarsCount() async throws -> NectarCount {
        let url = fullUrl(Endpoint.nectarsCount)
        let header = try authHeaders()
        return try await Http.asyncGet(url, headers: header)
    }
}

struct NectarCount: Codable {
    internal var totalNectar: Int
    
    enum CodingKeys: String, CodingKey {
        case totalNectar = "total_nectar"
    }
}
