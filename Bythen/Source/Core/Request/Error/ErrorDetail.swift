//
//  ErrorDetail.swift
//  Bythen
//
//  Created by Ega Setya on 13/12/24.
//

// MARK: - ErrorDetail
struct ErrorDetail: Codable {
    let errors: [ErrorInfo]?
    let error: String?
    let code: String?
}

// MARK: - Error
struct ErrorInfo: Codable {
    let message, id, code: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case id = "error_id"
        case code
    }
}
