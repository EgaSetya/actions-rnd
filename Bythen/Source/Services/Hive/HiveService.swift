//
//  HiveService.swift
//  Bythen
//
//  Created by erlina ng on 08/12/24.
//

import Foundation

protocol HiveServiceProtocol {
    func getHiveRank() async throws -> HiveRank
    
    func getHiveSummary(page: Int, limit: Int, aggregate: Bool) async throws -> HiveCommision
        
    func getHiveProducts() async throws -> HiveProductResponse
    
    func putHive() async throws
}

class HiveService: BythenApi, HiveServiceProtocol {
    enum Endpoint: ApiEndpointProtocol {
        case rank
        case point
        case expiredPoint
        case products
        case hive
        case withdrawals
        case withdrawalsInfo
        
        var path: String {
            switch self {
            case .rank: "/v1/me"
            case .point: "/v1/points"
            case .expiredPoint: "/v1/points/expired"
            case .products: "/v1/me/products"
            case .hive: "/v1/hive"
            case .withdrawals: "/v1/withdrawals"
            case .withdrawalsInfo: "/v1/withdrawals/info"
            }
        }
    }
    
    override init() {
        super.init(servicePath: AppConstants.kMSHiveName)
    }
    
    func getHiveRank() async throws -> HiveRank {
        return try await Http.get(fullUrl(Endpoint.rank), headers: try authHeaders())
    }
    
    func getHiveSummary(page: Int, limit: Int, aggregate: Bool) async throws -> HiveCommision {
        return try await Http.get(fullUrl(Endpoint.point), parameters: ["page": page, "limit": limit, "aggregate": aggregate], headers: try authHeaders())
    }
    
    func getExpiredPoints() async throws -> HiveExpiredPoints {
        return try await Http.get(fullUrl(Endpoint.expiredPoint), headers: try authHeaders())
    }

    func getHiveProducts() async throws -> HiveProductResponse {
        let url = fullUrl(Endpoint.products)
        let header = try authHeaders()
        return try await Http.asyncGet(url, headers: header)
    }
    
    func putHive() async throws {
        let _: EmptyBody = try await Http.put(
            fullUrl(Endpoint.hive),
            json: [String: Any](),
            headers: try authHeaders()
        )
    }
    
    func getWithdrawals(page: Int, limit: Int) async throws -> HiveWithdrawals {
        return try await Http.get(fullUrl(Endpoint.withdrawals), parameters: ["page": page, "limit": limit], headers: try authHeaders())
    }
    
    func getWithdrawalsInfo() async throws -> HiveWithdrawalsInfo {
        return try await Http.get(fullUrl(Endpoint.withdrawalsInfo), headers: try authHeaders())
    }
    
    func withdraw() async throws -> Withdrawal {
        return try await Http.post(fullUrl(Endpoint.withdrawals), headers: try authHeaders())
    }
}
