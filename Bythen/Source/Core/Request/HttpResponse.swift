//
//  HttpResponse.swift
//  Bythen
//
//  Created by edisurata on 30/08/24.
//

import Foundation
import Alamofire

struct EmptyBody: Codable, EmptyResponse {
    static func emptyValue() -> EmptyBody {
        return EmptyBody.init()
    }
}


class HttpResponse<T: Codable> {
    var dataResponse: DataResponse<T, AFError>
    
    init(_ dataResponse: DataResponse<T, AFError>) {
        self.dataResponse = dataResponse
    }
    
    func continueCheckResponse(_ continuation: CheckedContinuation<T, any Error>) {
        switch dataResponse.result {
        case .success(let value):
            Logger.logInfo(value)
            continuation.resume(returning: value)
            return
        case .failure(let error):
            if let resp = dataResponse.response {
                if resp.statusCode >= 200 && resp.statusCode < 300 {
                    if dataResponse.data == nil && T.self == EmptyBody.self {
                        Logger.logInfo("http empty body", context: ["status_code": resp.statusCode])
                        continuation.resume(returning: EmptyBody.emptyValue() as! T)
                        return
                    }
                    
                    if let decodingError = error.asAFError?.underlyingError as? DecodingError {
                        var info: String
                        switch decodingError {
                        case .keyNotFound(let key, let context):
                            info = "Key '\(key.stringValue)' was not found: \(context.debugDescription)"
                        case .typeMismatch(let type, let context):
                            info = "Type mismatch for type \(type): \(context.debugDescription)"
                        case .valueNotFound(let type, let context):
                            info = "Value not found for type \(type): \(context.debugDescription)"
                        case .dataCorrupted(let context):
                            info = "Data corrupted: \(context.debugDescription)"
                        @unknown default:
                            info = "Unknown decoding error"
                        }
                        
                        let error = HttpError(errorCode: .decodingError, debugData: ["info": info])
                        Logger.logError(err: error, context: ["info": info])
                        continuation.resume(throwing: error)
                        return
                    }
                } else {
                    let httpError = HttpError(statusCode: resp.statusCode)
                    
                    if let data = dataResponse.data,
                       let rawString = String(data: data, encoding: .utf8) {
                        let debugData = ["data": rawString]
                        httpError.description = decodeErrorDescription(debugData)
                        httpError.infos = decodeErrorInfo(debugData).errors
                        httpError.debugData = debugData
                    }
                    
                    Logger.logError(err: httpError, context: [
                        "url": resp.url?.absoluteString ?? "",
                        "code": httpError.code ?? -1,
                        "debugData": httpError.debugData ?? [:],
                    ])
                    continuation.resume(throwing: httpError)
                    return
                }
            }
            
            switch error {
            case .sessionTaskFailed(let urlError):
                if let urlError = urlError as? URLError, urlError.code == .notConnectedToInternet {
                    let err = HttpError(errorCode: .noInternetConnection)
                    continuation.resume(throwing: err)
                    return
                } else {
                    print("Network error: \(urlError.localizedDescription)")
                }
            default:
                print("Other error: \(error.localizedDescription)")
            }
            
            continuation.resume(throwing: error)
        }
    }
    
    private func decodeErrorDescription(_ data: [String: Any]) -> String? {
        do {
            guard let dataString = data["data"] as? String,
                  let jsonData = dataString.data(using: .utf8) else {
                throw HttpError(errorCode: .decodingError, debugData: data)
            }

            let error = try? JSONDecoder().decode(ErrorDetail.self, from: jsonData)
            
            return error?.error
        } catch {
            return nil
        }
    }
    
    private func decodeErrorInfo(_ data: [String: Any]) -> (errors: [ErrorInfo]?, code: String?) {
        do {
            guard let dataString = data["data"] as? String,
                  let jsonData = dataString.data(using: .utf8) else {
                throw HttpError(errorCode: .decodingError, debugData: data)
            }

            let error = try? JSONDecoder().decode(ErrorDetail.self, from: jsonData)
            
            return (error?.errors, error?.code)
        } catch {
            return (nil, nil)
        }
    }
}
