//
//  ChatbotService.swift
//  Bythen
//
//  Created by edisurata on 04/09/24.
//

import Foundation

struct GetUserTokensResponse: Codable {
    var token: String = ""
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}

struct GetSessionTokensResponse: Codable {
    var token: String = ""
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}

class ChatbotService: BythenApi {
    private let kServicePath = "/ms/chat-bot"
    private let kGetBytesCollectionsEndpoint = "/v1/bytes/aas"
    private let kGetUserTokensEndpoint = "/v1/user_tokens"
    private let kGetSessionTokensEndpoint = "/v1/session_tokens"
    
    override init() {
        super.init(servicePath: kServicePath)
    }
    
    private func kStreamMessageEndpoint(avatarID: Int) -> String {
        return "/v1/avatars/\(avatarID)/stream_messages"
    }
    
    func getBytes() async throws -> GetBytesResponse {
        let resp: GetBytesResponse = try await Http.get(self.urlForEndpoint(kGetBytesCollectionsEndpoint), headers: try authHeaders())
        
        return resp
    }
    
    func getUserTokens() async throws -> GetUserTokensResponse {
        let resp: GetUserTokensResponse = try await Http.get(self.urlForEndpoint(kGetUserTokensEndpoint))
        
        return resp
    }
    
    func getSessionTokens(userToken: String) async throws -> GetSessionTokensResponse {
        let resp: GetSessionTokensResponse = try await Http.get(self.urlForEndpoint(kGetSessionTokensEndpoint), headers: ["User-Token": userToken])
        
        return resp
    }
    
    func streamMessages(avatarID: Int, message: String, userToken: String, sessionToken: String) -> AsyncStream<[ChatResponse]> {
        let url = urlForEndpoint(kStreamMessageEndpoint(avatarID: avatarID))
        
        return AsyncStream { continuation in
            Task {
                for await resp in Http.postStreamString(url, json: ["messages": [["role": "user", "content": message]]], headers: ["User-Token": userToken, "Session-Token": sessionToken]) {
                    let jsonStrings = resp.split(separator: "\n").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
                    
                    var chatResponse: [ChatResponse] = []
                    
                    for jsonString in jsonStrings {
                        if jsonString.hasPrefix("data:") {
                            let jsonString = jsonString.replacingOccurrences(of: "data:", with: "")
                            
                            // Convert the JSON string to Data
                            if let jsonData = jsonString.data(using: String.Encoding.utf8) {
                                do {
                                    // Decode the JSON data into a DataItem object
                                    let chat = try JSONDecoder().decode(ChatResponse.self, from: jsonData)
                                    chatResponse.append(chat)
                                } catch {
                                    print("Error decoding JSON: \(error)")
                                }
                            }
                        }
                    }
                    
                    continuation.yield(chatResponse)
                }
                
                continuation.finish()
            }
        }
    }
    
}
