//
//  byteService.swift
//  Bythen
//
//  Created by edisurata on 19/09/24.
//

import Foundation

protocol ByteServiceProtocol {
    func getBytes() async throws -> GetBytesResponse
    func getBytesColorLogs() async throws -> ListColorLogs
    func getTrial() async throws -> FreeTrial
    func updateTrialDialogue(isDisplay: Bool) async throws
}

class ByteService: BythenApi, ByteServiceProtocol {
    enum Endpoint: ApiEndpointProtocol {
        case getBytes
        case getListColorLogs
        case trial

        var path: String {
            switch self {
            case .getBytes:
                return "/v1/bytes"
            case .getListColorLogs:
                return "/v1/bytes/colors"
            case .trial:
                return "/v1/bytes/trial"
            }
        }
    }

    override init() {
        super.init(servicePath: AppConstants.kMSChatbotName)
    }

    func getBytes() async throws -> GetBytesResponse {
        let url = fullUrl(Endpoint.getBytes)
        let header = try authHeaders()
        let resp: GetBytesResponse = try await Http.asyncGet(url, headers: header)
        return resp
    }

    func getBytesColorLogs() async throws -> ListColorLogs {
        let url = fullUrl(Endpoint.getListColorLogs)
        let resp: ListColorLogs = try await Http.get(url, parameters: ["limit": 8], headers: authHeaders())
        return resp
    }

    func getTrial() async throws -> FreeTrial {
        let url = fullUrl(Endpoint.trial)
        let resp: FreeTrial = try await Http.get(url, headers: authHeaders())
        return resp
    }

    func updateTrialDialogue(isDisplay: Bool) async throws {
        let url = fullUrl(Endpoint.trial)
        let _: EmptyBody = try await Http.put(url, json: ["is_end_dialogue_displayed": isDisplay], headers: authHeaders())
    }
}
