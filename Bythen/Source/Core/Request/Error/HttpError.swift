//
//  HttpErrors.swift
//  Bythen
//
//  Created by edisurata on 19/09/24.
//

import Foundation

enum HttpErrorCode: Int {
    case unauthorized = 401
    case notFound = 404
    case badRequest = 400
    case forbidden = 403
    case internalServerError = 500
    case decodingError = 1
    case noInternetConnection = 2
    case unknown
    
    var message: String {
        switch self {
        case .unauthorized: "401 Unauthorized"
        case .notFound: "404 Not Found"
        case .badRequest: "400 Bad Request"
        case .forbidden: "403 Forbidden"
        case .internalServerError: "500 Internal Server Error"
        case .decodingError: "Response Decode Error"
        case .noInternetConnection: "No Internet Connection"
        default: "Unknown Error"
        }
    }
}

class HttpError: Error, LocalizedError {
    var message: String
    var description: String?
    var code: HttpErrorCode?
    var infos: [ErrorInfo]?
    var debugData: [String: Any]?
    
    init(statusCode: Int) {
        let errorCode = HttpErrorCode(rawValue: statusCode)
        self.code = errorCode
        self.message = errorCode?.message ?? ""
    }
    
    init(errorCode: HttpErrorCode) {
        self.code = errorCode
        self.message = errorCode.message
    }
    
    init(errorCode: HttpErrorCode, debugData: [String : Any]? = nil) {
        self.code = errorCode
        self.message = errorCode.message
        self.debugData = debugData
    }
}
