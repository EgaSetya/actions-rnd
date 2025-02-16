//
//  ByteBuildService.swift
//  Bythen
//
//  Created by edisurata on 20/09/24.
//

import Foundation

protocol ByteBuildServiceProtocol {
    func createBuild(params: CreateBuildParams) async throws
    func getBuildDefault() async throws -> ByteBuild
    func getBuild(byteID: Int64, byteSymbol: String) async throws -> ByteBuild
    func setBuildAsPrimary(byteID: Int64, byteSymbol: String) async throws
    func generateDescription(buildID: Int64, params: ByteDescriptionParams) async throws -> ByteDescriptionResponse
    func updateDescription(byteID: Int64, byteSymbol: String, description: String) async throws
    func wipeProfile(byteID: Int64, byteSymbol: String) async throws
    func updateBuild(byteBuild: ByteBuild) async throws
    func updateBackground(byteID: Int64, byteSymbol: String, background: String, backgroundType: BackgroundType) async throws
    func updateByteProfile(byteID: Int64, byteSymbol: String, params: UpdateByteBuildProfileParams) async throws
    func updateGreetings(byteID: Int64, byteSymbol: String, greetings: String) async throws
    func updateDialogueStyle(byteID: Int64, byteSymbol: String, responseLength: Int64, dialogueStyle: String, isCustom: Bool) async throws
    func updateVoiceModel(byteID: Int64, byteSymbol: String, params: UpdateByteBuildVoiceParam) async throws
    func updateDialoguePreview(buildID: Int64, responseLength: Int64, dialogueStyle: String, isCustom: Bool) async throws -> String
    func updatePersonality(byteID: Int64, byteSymbol: String, introvert: Int64, open: Int64, agreeable: Int64, apathy: Int64, spontaneous: Int64, lively: Int64) async throws
    func updateTraits(byteID: Int64, byteSymbol: String, traits: [String]) async throws
    func updateBuildUsed(buildID: Int64) async throws
}

class ByteBuildService: BythenApi, ByteBuildServiceProtocol {
    enum Endpoint: ApiEndpointProtocol {
        case createBuild
        case getDefault
        case getBuild(byteID: Int64, byteSymbol: String)
        case updateBuild(byteID: Int64, byteSymbol: String)
        case generateDescription(buildID: Int64)
        case updateDialoguePreview(Int64)
        case updateBuildUsed(buildID: Int64)

        var path: String {
            switch self {
            case .createBuild:
                return "/v1/builds"
            case .getDefault:
                return "/v1/builds/default"
            case let .getBuild(byteID, byteSymbol):
                return "/v1/builds/\(byteID)/\(byteSymbol)"
            case let .updateBuild(byteID, byteSymbol):
                return "/v1/builds/\(byteID)/\(byteSymbol)"
            case let .generateDescription(buildID):
                return "/v1/chats/bytes/description/\(buildID)"
            case let .updateDialoguePreview(buildID):
                return "/v1/chats/bytes/dialogue/\(buildID)"
            case let .updateBuildUsed(buildID):
                return "/v1/builds/used/\(buildID)"
            }
        }
    }

    override init() {
        super.init(servicePath: AppConstants.kMSChatbotName)
    }

    func createBuild(params: CreateBuildParams) async throws {
        let url = fullUrl(Endpoint.createBuild)
        let _: [String: Int64] = try await Http.post(url, json: params, headers: authHeaders())
    }

    func getBuildDefault() async throws -> ByteBuild {
        let url = fullUrl(Endpoint.getDefault)
        var resp: BuildResponse = try await Http.get(url, headers: authHeaders())
        resp.build.roomID = resp.roomID
        return resp.build
    }

    func getBuild(byteID: Int64, byteSymbol: String) async throws -> ByteBuild {
        let url = fullUrl(Endpoint.getBuild(byteID: byteID, byteSymbol: byteSymbol))
        var resp: BuildResponse = try await Http.get(url, headers: authHeaders())
        resp.build.roomID = resp.roomID
        return resp.build
    }
    
    func updateBuild(byteBuild: ByteBuild) async throws {
        let url = fullUrl(Endpoint.updateBuild(byteID: byteBuild.byteId, byteSymbol: byteBuild.byteSymbol))
        let _: EmptyBody = try await Http.put(
            url,
            json: byteBuild.convertToJSON(),
            headers: try authHeaders()
        )
    }

    func setBuildAsPrimary(byteID: Int64, byteSymbol: String) async throws {
        let url = fullUrl(Endpoint.updateBuild(byteID: byteID, byteSymbol: byteSymbol))
        let _: EmptyBody = try await Http.put(url, json: ["is_primary": true], headers: authHeaders())
    }

    func generateDescription(buildID: Int64, params: ByteDescriptionParams) async throws -> ByteDescriptionResponse {
        let url = fullUrl(Endpoint.generateDescription(buildID: buildID))
        return try await Http.post(url, json: params, headers: authHeaders())
    }

    func updateDescription(byteID: Int64, byteSymbol: String, description: String) async throws {
        let url = fullUrl(Endpoint.updateBuild(byteID: byteID, byteSymbol: byteSymbol))
        let _: EmptyBody = try await Http.put(url, json: ["description": description], headers: authHeaders())
    }

    
    func wipeProfile(byteID: Int64, byteSymbol: String) async throws {
        let url = fullUrl(Endpoint.updateBuild(byteID: byteID, byteSymbol: byteSymbol))
        let _: EmptyBody = try await Http.put(url, json: ["is_active": false], headers: try authHeaders())
    }
    
    func updateBackground(byteID: Int64, byteSymbol: String, background: String, backgroundType: BackgroundType) async throws {
        let url = fullUrl(Endpoint.updateBuild(byteID: byteID, byteSymbol: byteSymbol))
        let _: EmptyBody = try await Http.put(
            url,
            json: ["background": background, "background_type": backgroundType.rawValue],
            headers: authHeaders()
        )
    }

    func updateByteProfile(byteID: Int64, byteSymbol: String, params: UpdateByteBuildProfileParams) async throws {
        let url = fullUrl(Endpoint.updateBuild(byteID: byteID, byteSymbol: byteSymbol))
        let _: EmptyBody = try await Http.put(url, json: params, headers: authHeaders())
    }

    func updateGreetings(byteID: Int64, byteSymbol: String, greetings: String) async throws {
        let url = fullUrl(Endpoint.updateBuild(byteID: byteID, byteSymbol: byteSymbol))
        let _: EmptyBody = try await Http.put(url, json: ["greetings": greetings], headers: authHeaders())
    }

    func updateDialogueStyle(byteID: Int64, byteSymbol: String, responseLength: Int64, dialogueStyle: String, isCustom: Bool = false) async throws {
        let url = fullUrl(Endpoint.updateBuild(byteID: byteID, byteSymbol: byteSymbol))
        let params: [String: Any] = ["response_length": responseLength, "dialogue_style": dialogueStyle, "is_custom_dialogue": isCustom]
        let _: EmptyBody = try await Http.put(url, json: params, headers: authHeaders())
    }

    func updateVoiceModel(byteID: Int64, byteSymbol: String, params: UpdateByteBuildVoiceParam) async throws {
        let url = fullUrl(Endpoint.updateBuild(byteID: byteID, byteSymbol: byteSymbol))
        let _: EmptyBody = try await Http.put(url, json: params, headers: authHeaders())
    }

    func updateDialoguePreview(buildID: Int64, responseLength: Int64, dialogueStyle: String, isCustom: Bool) async throws -> String {
        let params: [String: Any] = [
            "dialogue_style": dialogueStyle,
            "is_custom_dialogue": isCustom,
            "response_length": responseLength,
        ]
        let url = fullUrl(Endpoint.updateDialoguePreview(buildID))
        let resp: [String: String] = try await Http.put(url, json: params, headers: authHeaders())
        return resp["dialogue"] ?? ""
    }
    
    func updatePersonality(byteID: Int64, byteSymbol: String, introvert: Int64, open: Int64, agreeable: Int64, apathy: Int64, spontaneous: Int64, lively: Int64) async throws {
        let url = fullUrl(Endpoint.updateBuild(byteID: byteID, byteSymbol: byteSymbol))
        let params: [String: Any] = [
            "introvert": introvert,
            "open": open,
            "agreeable": agreeable,
            "apathy": apathy,
            "spontaneous": spontaneous,
            "lively": lively
        ]
        let _: EmptyBody = try await Http.put(
            url,
            json: params,
            headers: try authHeaders()
        )
    }
    
    func updateTraits(byteID: Int64, byteSymbol: String, traits: [String]) async throws {
        let url = fullUrl(Endpoint.updateBuild(byteID: byteID, byteSymbol: byteSymbol))
        let params: [String: Any] = [
            "traits": traits
        ]
        let _: EmptyBody = try await Http.put(
            url,
            json: params,
            headers: try authHeaders()
        )
    }
    
    func updateBuildUsed(buildID: Int64) async throws {
        do {
            let url = fullUrl(Endpoint.updateBuildUsed(buildID: buildID))
            let _: EmptyBody = try await Http.put(url, headers: try authHeaders())
            Logger.logInfo("Success Update Build Used")
        } catch {
            Logger.logError(err: error)
            throw error
        }
    }
}
