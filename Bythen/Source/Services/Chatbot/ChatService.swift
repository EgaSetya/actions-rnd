//
//  ChatService.swift
//  Bythen
//
//  Created by edisurata on 26/09/24.
//

import Foundation

protocol ChatServiceProtocol {
    func chatBytes(buildID: Int64, roomID: Int64, message: String, fileURL: String?) -> AsyncStream<[ChatResponse]>
    func chatBytesHistory(buildID: Int64, roomID: Int64) async throws -> ChatHistoryResponse
    func chatBytesSummary(buildID: Int64, roomID: Int64) async throws -> ChatSummaryResponse
    func chatBytesRegenerate(buildID: Int64, roomID: Int64) -> AsyncStream<[ChatResponse]>
    func chatBytesThumbsDown(buildID: Int64, roomID: Int64, chatID: Int64) async throws -> ThumbsdownResponse
}

class ChatService: BythenApi, ChatServiceProtocol {
    override init() {
        super.init(servicePath: AppConstants.kMSChatbotName)
    }

    private func urlForChatBytes(buildID: Int64, roomID: Int64) -> String {
        return urlForEndpoint("/v1/chats/bytes/\(buildID)/\(roomID)")
    }

    private func urlForChatBytesHistory(buildID: Int64, roomID: Int64) -> String {
        return urlForEndpoint("/v1/chats/bytes/histories/\(buildID)/\(roomID)")
    }

    private func urlForChatBytesSummary(buildID: Int64, roomID: Int64) -> String {
        return urlForEndpoint("/v1/chats/bytes/summary/\(buildID)/\(roomID)")
    }

    private func urlForChatBytesRegenerate(buildID: Int64, roomID: Int64) -> String {
        return urlForEndpoint("/v1/chats/bytes/regenerate/\(buildID)/\(roomID)")
    }

    private func urlForChatBytesThumbsDown(buildID: Int64, roomID: Int64, chatID: Int64) -> String {
        return urlForEndpoint("/v1/chats/bytes/thumbs-down/\(buildID)/\(roomID)/\(chatID)")
    }

    func chatBytes(buildID: Int64, roomID: Int64, message: String, fileURL: String?) -> AsyncStream<[ChatResponse]> {
        let url = urlForChatBytes(buildID: buildID, roomID: roomID)
        var params = ["content": message]

        if let fileURL {
            params["file_url"] = fileURL
        }

        return AsyncStream { continuation in
            Task {
                for await resp in try Http.postStreamString(url, json: params, headers: authHeaders()) {
                    let jsonStrings = resp
                        .split(separator: "\n")
                        .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }

                    var chatResponse: [ChatResponse] = []

                    for jsonString in jsonStrings {
                        if jsonString.hasPrefix("data:") {
                            let jsonString = jsonString.replacingOccurrences(
                                of: "data:",
                                with: ""
                            )

                            if let jsonData = jsonString.data(using: String.Encoding.utf8) {
                                do {
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

    func chatBytesHistory(buildID: Int64, roomID: Int64) async throws -> ChatHistoryResponse {
        let url = urlForChatBytesHistory(buildID: buildID, roomID: roomID)
        return try await Http.get(url, parameters: ["limit": 100], headers: authHeaders())
    }

    func chatBytesSummary(buildID: Int64, roomID: Int64) async throws -> ChatSummaryResponse {
        let url = urlForChatBytesSummary(buildID: buildID, roomID: roomID)
        return try await Http.post(url, headers: authHeaders())
    }

    func chatBytesRegenerate(buildID: Int64, roomID: Int64) -> AsyncStream<[ChatResponse]> {
        let url = urlForChatBytesRegenerate(buildID: buildID, roomID: roomID)
        return AsyncStream { continuation in
            Task {
                for await resp in try Http.postStreamString(url, json: ["": ""], headers: authHeaders()) {
                    let jsonStrings = resp.split(separator: "\n").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }

                    var chatResponse: [ChatResponse] = []

                    for jsonString in jsonStrings {
                        if jsonString.hasPrefix("data:") {
                            let jsonString = jsonString.replacingOccurrences(of: "data:", with: "")

                            /// Convert the JSON string to Data
                            if let jsonData = jsonString.data(using: String.Encoding.utf8) {
                                do {
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

    func chatBytesThumbsDown(buildID: Int64, roomID: Int64, chatID: Int64) async throws -> ThumbsdownResponse {
        let url = urlForChatBytesThumbsDown(buildID: buildID, roomID: roomID, chatID: chatID)
        return try await Http.put(url, headers: authHeaders())
    }
}
