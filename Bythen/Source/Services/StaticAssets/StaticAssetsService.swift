//
//  StaticAssetsService.swift
//  Bythen
//
//  Created by edisurata on 10/09/24.
//

import Foundation

enum AssetsPath: String {
    case stickers = "/dojo/onboarding/stickers.json"
    case voiceTags = "/dojo/voice-tags.json"
    case dialogueStyles = "/dojo/dialogue-styles.json"
    case personalities = "/dojo/personalities.json"
    case appVersion = "/app-update/bythen-app-ios/version.json"
    case hiveRankRules = "/hive/rank-rules.json"
    case hiveOnboarding = "/hive/onboarding.json"
}

protocol StaticAssetsServiceProtocol {
    func getAssets<T: Codable>(path: AssetsPath) async throws -> T
    func loadStaticDefaultValues<T: Codable>(path: AssetsPath) throws -> T
}

class StaticAssetsService: BythenApi, StaticAssetsServiceProtocol {
    func getAssets<T: Codable>(path: AssetsPath) async throws -> T {
        do {
            let resp: T = try await Http.get(AppConfig.staticAssetsBaseUrl + path.rawValue)
            return resp
        } catch {
            return try loadStaticDefaultValues(path: path)
        }
    }

    func loadStaticDefaultValues<T: Codable>(path: AssetsPath) throws -> T {
        var jsonString = ""
        switch path {
        case .stickers:
            jsonString = StaticDefaultValues.staticStickersJson
        case .voiceTags:
            jsonString = StaticDefaultValues.staticVoiceTagsJson
        case .dialogueStyles:
            jsonString = StaticDefaultValues.staticDialogueStylePresetsJson
        case .personalities:
            jsonString = StaticDefaultValues.staticPersonalitiesJson
        case .appVersion:
            jsonString = StaticDefaultValues.staticMinimumAppVersionJson
        case .hiveRankRules:
            jsonString = StaticDefaultValues.staticHiveRankRulesJson
        case .hiveOnboarding:
            jsonString = StaticDefaultValues.defaultHiveOnboardingJson
        }

        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let resp = try JSONDecoder().decode(T.self, from: jsonData)
                return resp
            } catch {
                throw error
            }
        }

        throw AppError(code: 1, message: "Invalid Static Default Values")
    }
}
