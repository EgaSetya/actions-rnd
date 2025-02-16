//
//  UploadFileService.swift
//  Bythen
//
//  Created by Darindra R on 06/10/24.
//

import Foundation

protocol UploadFileServiceProtocol {
    func uploadFile(buildID: Int64, fileURL: URL) async throws -> UploadFileResponse
}

class UploadFileService: BythenApi, UploadFileServiceProtocol {
    override init() {
        super.init(servicePath: AppConstants.kMSMediaName)
    }

    private func urlForUploadFile(buildID: Int64) -> String {
        return urlForEndpoint("/v1/bytes/chats/\(buildID)")
    }

    func uploadFile(buildID: Int64, fileURL: URL) async throws -> UploadFileResponse {
        try await Http.uploadFile(
            urlForUploadFile(buildID: buildID),
            fileUrl: fileURL,
            fileKey: "file",
            headers: authHeaders()
        )
    }
}
