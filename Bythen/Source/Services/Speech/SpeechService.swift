//
//  SpeechService.swift
//  Bythen
//
//  Created by edisurata on 17/09/24.
//

import Foundation

protocol SpeechServiceProtocol {
    func transcript(fileUrl: URL) async throws -> String
    func getVoices(base: String, accent: String, age: String) async throws -> [Voice]
}

class SpeechService: BythenApi, SpeechServiceProtocol {
    private let kServicePath = "/ms/speech"
    private let kTranscriptEndpoint = "/v1/transcriptions"
    private let kGetVoicesEndpoint = "/v1/voices"
    
    override init() {
        super.init(servicePath: kServicePath)
    }
    
    func transcript(fileUrl: URL) async throws -> String {
        let resp: TranscriptResponse = try await Http.uploadFile(urlForEndpoint(kTranscriptEndpoint), fileUrl: fileUrl, fileKey: "file", params: ["provider": "deepgram"], headers: try authHeaders())
        
        return resp.text
    }
    
    func getVoices(base: String, accent: String, age: String) async throws -> [Voice] {
        let params = ["base": base, "accent": accent, "age": age]
        let resp: GetVoicesResponse = try await Http.get(urlForEndpoint(kGetVoicesEndpoint), parameters: params, headers: try authHeaders())
        
        return resp.voices
    }
}
