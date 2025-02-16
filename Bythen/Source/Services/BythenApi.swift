//
//  BythenApiService.swift
//  Bythen
//
//  Created by edisurata on 15/08/24.
//

import Foundation

protocol ApiEndpointProtocol {
    var path: String { get }
}

class BythenApi {
    
    private var servicePath: String!
    
    init() {}
    
    init(servicePath: String) {
        self.servicePath = servicePath
    }
    
    func urlForEndpoint(_ endpoint: String) -> String {
        return AppConfig.apiBaseUrl + self.servicePath + endpoint
    }
    
    func fullUrl(_ endpoint: ApiEndpointProtocol) -> String {
        return AppConfig.apiBaseUrl + self.servicePath + endpoint.path
    }
    
    func authHeaders() throws -> [String: String] {
        guard let authToken = AppSession.shared.getAuthToken() else {
            throw HttpError(errorCode: .unauthorized)
        }
        
        return ["Authorization": "Bearer " + authToken]
    }
}
