//
//  CreateBuild.swift
//  Bythen
//
//  Created by edisurata on 20/09/24.
//

import Foundation

struct CreateBuildParams: Codable {
    var byteID: Int64
    var byteSymbol: String
    var mode: String
    var byteName: String
    var age: Int64
    var gender: String
    
    enum CodingKeys: String, CodingKey {
        case byteID = "byte_id"
        case byteSymbol = "byte_symbol"
        case mode = "mode"
        case byteName = "byte_name"
        case age = "age"
        case gender = "gender"
    }
}

struct UpdateByteBuildProfileParams: Codable {
    var byteName: String
    var gender: String
    var age: Int64
    var role: String
    
    enum CodingKeys: String, CodingKey {
        case byteName = "byte_name"
        case gender = "gender"
        case age = "age"
        case role = "role"
    }
}

struct UpdateByteBuildVoiceParam: Codable {
    var base: String
    var accents: String
    var age: String
    var model: String
    
    enum CodingKeys: String, CodingKey {
        case base = "voice_base"
        case accents = "voice_accent"
        case age = "voice_age"
        case model = "voice_model"
    }
}
