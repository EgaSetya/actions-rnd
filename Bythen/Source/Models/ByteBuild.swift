//
//  ByteBuild.swift
//  Bythen
//
//  Created by edisurata on 23/09/24.
//

import BetterCodable
import Foundation

enum BackgroundType: String, Codable {
    case image
    case color
}

enum ByteGender: String, Codable {
    case male = "male"
    case female = "female"
    case nonbinary = "non-binary"
    case empty = ""
}

struct ByteStarterChat: Codable, Equatable, Hashable {
    let text: String

    enum CodingKeys: String, CodingKey {
        case text = "value"
    }
}

struct ByteBuild: Codable, Identifiable {
    let id = UUID()
    @DefaultZeroInt64 var buildID: Int64 = 0
    @DefaultEmptyString var buildName: String = ""
    @DefaultEmptyString var address: String = ""
    @DefaultZeroInt64 var byteId: Int64 = 0
    @DefaultEmptyString var byteSymbol: String = ""
    @DefaultEmptyString var byteName: String = ""
    @DefaultEmptyByteGender var gender: ByteGender = .empty
    @DefaultZeroInt64 var age: Int64 = 0
    @DefaultEmptyString var role: String = ""
    @DefaultZeroInt64 var exp: Int64 = 0
    @DefaultEmptyString var description: String = ""
    @DefaultFalse var isActive: Bool = false
    @DefaultFalse var isPrimary: Bool = false
    @DefaultZeroInt64 var introvert: Int64 = 0
    @DefaultZeroInt64 var open: Int64 = 0
    @DefaultZeroInt64 var agreeable: Int64 = 0
    @DefaultZeroInt64 var apathy: Int64 = 0
    @DefaultZeroInt64 var spontaneous: Int64 = 0
    @DefaultZeroInt64 var lively: Int64 = 0
    @DefaultEmptyArray var traits: [String] = [""]
    @DefaultFalse var dynamicMood: Bool = false
    @DefaultZeroInt64 var frequency: Int64 = 0
    @DefaultZeroInt64 var responseLength: Int64 = 0
    @DefaultEmptyString var dialogueStyle: String = ""
    @DefaultEmptyString var knowledgeSource: String = ""
    @DefaultEmptyString var prompts: String = ""
    @DefaultEmptyString var voiceBase: String = ""
    @DefaultEmptyString var voiceAccents: String = ""
    @DefaultEmptyString var voiceAge: String = ""
    @DefaultEmptyString var voicePreset: String = ""
    @DefaultEmptyString var voiceModel: String = ""
    @DefaultEmptyString var lastUsed: String = ""
    @DefaultEmptyString var background: String = ""
    @DefaultBackgroundType var backgroundType: BackgroundType = .color
    @DefaultZeroInt64 var totalKnowledge: Int64 = 0
    @DefaultZeroInt64 var totalMemories: Int64 = 0
    @DefaultEmptyString var sampleDialogue: String = ""
    @DefaultEmptyDictionary var personalities: [Int: Personality] = [:]
    @DefaultEmptyArray var starterChats: [ByteStarterChat] = []
    @DefaultByteData var byteData: ByteData = .init()
    @DefaultZeroInt64 var roomID: Int64 = 0
    @DefaultEmptyString var greetings: String = ""
    @DefaultFalse var isCustomDialogue: Bool = false
    @DefaultZeroInt64 var voicePitch: Int64 = 0

    enum CodingKeys: String, CodingKey {
        case buildID = "id"
        case buildName = "build_name"
        case address
        case byteId = "byte_id"
        case byteSymbol = "byte_symbol"
        case byteName = "byte_name"
        case gender
        case age
        case role
        case exp
        case description
        case isActive = "is_active"
        case isPrimary = "is_primary"
        case introvert
        case open
        case agreeable
        case apathy
        case spontaneous
        case lively
        case traits
        case dynamicMood = "dynamic_mood"
        case frequency
        case responseLength = "response_length"
        case dialogueStyle = "dialogue_style"
        case knowledgeSource = "knowledge_source"
        case prompts
        case voiceBase = "voice_base"
        case voiceAccents = "voice_accent"
        case voiceAge = "voice_age"
        case voicePreset = "voice_preset"
        case voiceModel = "voice_model"
        case lastUsed = "last_used"
        case background
        case backgroundType = "background_type"
        case totalKnowledge = "total_knowledge"
        case totalMemories = "total_memories"
        case sampleDialogue = "sample_dialogue"
        case personalities
        case starterChats = "starter_chats"
        case byteData = "byte_data"
        case roomID = "room_id"
        case greetings
        case isCustomDialogue = "is_custom_dialogue"
        case voicePitch = "voice_pitch"
    }

    init() {}
    
    internal func convertToJSON() -> [String: Any] {
        return [
            "age": self.age,
            "agreeable": self.agreeable,
            "apathy": self.apathy,
            "background": self.background,
            "background_type": self.backgroundType,
            "build_name": self.buildName,
            "byte_name": self.byteName,
            "description": self.description,
            "dialogue_style": self.dialogueStyle,
            "dynamic_mood": self.dynamicMood,
            "gender": self.gender,
            "greetings": self.greetings,
            "introvert": self.introvert,
            "is_active": self.isActive,
            "is_custom_dialogue": true,
            "is_primary": self.isPrimary,
            "knowledge_source": self.knowledgeSource,
            "lively": self.lively,
            "open": self.open,
            "response_length": self.responseLength,
            "role": self.role,
            "spontaneous": self.spontaneous,
            "traits": self.traits,
            "voice_accent": self.voiceAccents,
            "voice_age": self.voiceAge,
            "voice_base": self.voiceBase,
            "voice_model": self.voiceModel
        ]
    }
}
