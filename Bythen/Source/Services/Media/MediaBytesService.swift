//
//  MediaService.swift
//  Bythen
//
//  Created by edisurata on 29/09/24.
//

import Foundation

protocol MediaBytesServiceProtocol {
    func getBytesBackgrounds(symbol: String) async throws -> ListMediaBytesBackgrounds
    func getBytesBackgroundImages() async throws -> ListMediaBytesBackgroundImages
    func uploadBackgroundImage(fileUrl: URL) async throws -> UploadMediaBytesBackgorundImageResponse
    func deleteBackgroundImage(fileUrl: String) async throws
    func uploadChatFile(fileUrl: URL, buildID: Int64, progressHandler: @escaping (Double) -> Void) async throws -> UploadFileResponse
}

class MediaBytesService: BythenApi, MediaBytesServiceProtocol {
    
    enum Endpoint: ApiEndpointProtocol {
        case uploadChatFile(buildID: Int64)
        
        var path: String {
            switch self {
            case .uploadChatFile(let buildID):
                return "/v1/bytes/chats/\(buildID)"
            }
        }
    }
    
    private let kGetBytesBackgrounds = "/v1/bytes/backgrounds"
    private let kGetBytesBackgroundImages = "/v1/bytes/background-images"
    private let kGetBytesBackgroundAssets = "/v1/bytes/background-assets"
    private let kUploadBytesBackgroundImages = "/v1/bytes/background-images"
    
    override init() {
        super.init(servicePath: AppConstants.kMSMediaName)
    }
    
    func getBytesBackgrounds(symbol: String) async throws -> ListMediaBytesBackgrounds {
        let url = urlForEndpoint(kGetBytesBackgrounds)
        return try await Http.get(url, parameters: ["byte_symbol": symbol], headers: try authHeaders())
    }
    
    func getBytesBackgroundImages() async throws -> ListMediaBytesBackgroundImages {
        let url = urlForEndpoint(kGetBytesBackgroundImages)
        return try await Http.get(url, parameters: ["limit": 5], headers: try authHeaders())
    }
    
    func uploadBackgroundImage(fileUrl: URL) async throws -> UploadMediaBytesBackgorundImageResponse {
        let url = urlForEndpoint(kUploadBytesBackgroundImages)
        return try await Http.uploadFile(url, fileUrl: fileUrl, fileKey: "file", headers: try authHeaders())
    }
    
    func deleteBackgroundImage(fileUrl: String) async throws {
        let _: EmptyBody = try await Http.delete(fileUrl, headers: try authHeaders())
    }
    
    func uploadChatFile(fileUrl: URL, buildID: Int64, progressHandler: @escaping (Double) -> Void) async throws -> UploadFileResponse {
        return try await Http.uploadFile(
            fullUrl(Endpoint.uploadChatFile(buildID: buildID)),
            fileUrl: fileUrl,
            fileKey: "file",
            headers: authHeaders(),
            progressHandler: progressHandler
        )
    }
}
