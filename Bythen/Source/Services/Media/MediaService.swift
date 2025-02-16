//
//  MediaService.swift
//  Bythen
//
//  Created by Ega Setya on 17/12/24.
//

import Foundation

protocol MediaService {
    func uploadImage(imageURL: URL) async throws -> Media
}

class DefaultMediaService: BythenApi, MediaService {
    private let kServicePath = "/ms/media-upload"
    
    enum Endpoint: ApiEndpointProtocol {
        case uploadProfileImage
        
        var path: String {
            switch self {
            case .uploadProfileImage: return "/v1/upload"
            }
        }
    }
    
    override init() {
        super.init(servicePath: kServicePath)
        
    }
    
    func uploadImage(imageURL: URL) async throws -> Media {
        let url = fullUrl(Endpoint.uploadProfileImage)
        return try await Http.uploadFile(url, fileUrl: imageURL, fileKey: "file", headers: try authHeaders())
    }
}
