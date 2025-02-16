//
//  UnityAPI.swift
//  Bythen
//
//  Created by edisurata on 29/07/24.
//

import Foundation

struct StudioRecordVoiceRequest: Codable, Hashable {
    var voiceID: String
    var voicePitch: Int64
    var voiceTexts: [String]
    
    enum CodingKeys: String, CodingKey {
        case voiceID
        case voicePitch
        case voiceTexts
    }
}

class UnityApi: UnityApiProtocol {
    
    static var shared = UnityApi()
    
    private let objectName = "Manager"
    private let methodName = "QueueEvent"
    
    init() {}
    
    func setAvatar(avatarID: String) {
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/setting-change-character\",\"data\":{\"avatarID\": \"\(avatarID)\"}}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func startAvatarAnimation() {
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/chatbot-start-process\"}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func stopAvatarAnimation() {
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/chatbot-end-process\"}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func triggerAvatarVoice(_ voice: String, emotion: String, voiceID: String, voicePitch: Int64) {
//        let filteredVoice = self.removeEmojis(from: voice)
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/chatbot-voice-send\",\"data\":{\"voice\": \"\(voice)\",\"emotion\":\"\(emotion)\",\"voiceID\":\"\(voiceID)\",\"voicePitch\":\(voicePitch)}}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func setBackgroundColor(hexColorString: String) {
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/change-background-color\",\"data\":{\"hexColor\": \"\(hexColorString)\"}}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func stopGenerate() {
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/stop-generate\"}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func changeAvatarTraits(_ traits: String) {
        var traits = traits
        if traits == "" {
            traits = "null"
        }
        
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/change-character-by-traits\",\"data\":\(traits)}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func endChatResponse() {
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/chatbot-end-process\"}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func startAvatar(_ traits: String) {
        UnityApp.resumeActivityt()
        self.changeAvatarTraits(traits)
    }
    
    func stopAvatar() {
//        self.changeAvatarTraits("{}")
//        UnityApp.pauseActivity()
    }
    
    func prepareAvatar() {
        UnityApp.resumeActivityt()
    }
    
    func setBackgroundImage(imageUrl: String) {
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/change-background-image\",\"data\":{\"imageUri\" : \"\(imageUrl)\"}}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func changeProductType(productType: UnityProductType) {
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/change-product-type\",\"data\":\(productType.rawValue)}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func hideCharacter(delay: Float) {
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/hide-character\",\"data\":\(delay)}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func showCharacter(delay: Float) {
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/show-character\",\"data\":\(delay)}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func setupEnvironment(env: String = "production") {
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/set-environment\",\"data\":\"\(env)\"}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func changeTheme(theme: Int) {
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/setting-change-theme\",\"data\":\"\(theme)\"}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func setTalkingSpeed(value: Float) {
        
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/set-talking-speed\",\"data\":\(value)}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func requestAudio(voiceID: String, voicePitch: Int64, voiceTexts: [String]) {
        let req = StudioRecordVoiceRequest(voiceID: voiceID, voicePitch: voicePitch, voiceTexts: voiceTexts)
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\":\"app/studio-request-audio\",\"data\":\(convertToJSONString(from: req) ?? "null")}")
        UnityApp.sendMessageToUnity(message)
    }
    
    func startRecord() {
        let message = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: "{\"event\": \"app/studio-start-record\"}")
        UnityApp.sendMessageToUnity(message)
    }
    
    private func convertToJSONString<T: Encodable>(from object: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // Optional: for readable formatting
        do {
            let jsonData = try encoder.encode(object)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Failed to encode object to JSON: \(error)")
            return nil
        }
    }
    
    private func removeEmojis(from text: String) -> String {
        let filteredText = text.filter { character in
            for scalar in character.unicodeScalars {
                switch scalar.value {
                case 0x1F600...0x1F64F, // Emoticons
                     0x1F300...0x1F5FF, // Miscellaneous Symbols and Pictographs
                     0x1F680...0x1F6FF, // Transport and Map Symbols
                     0x2600...0x26FF,   // Miscellaneous Symbols
                     0x2700...0x27BF,   // Dingbats
                     0x1F1E6...0x1F1FF: // Flags
                    return false
                default:
                    continue
                }
            }
            return true
        }
        return filteredText
    }
}
