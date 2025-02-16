//
//  Http.swift
//  Bythen
//
//  Created by edisurata on 30/08/24.
//

import Foundation
import Alamofire

class Http {
    static func asyncGet<T: Codable>(
        _ url: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil) async throws -> T
    {
        let reqHeaders = HttpHeader(headers)
        do {
            let resp = try await AF.request(
                url,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: reqHeaders.getHeaders())
                .cacheResponse(using: .cache)
                .validate()
                .serializingDecodable(T.self)
                .value
            
            return resp
        } catch let err {
            throw err
        }
    }
    
    static func get<T: Codable>(
        _ url: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        cache: Bool = true) async throws -> T
    {
        return try await withCheckedThrowingContinuation { continuation in
            let reqHeaders = HttpHeader(headers)
            AF.request(
                url,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: reqHeaders.getHeaders())
            .cacheResponse(using: cache ? .cache : .doNotCache)
            .validate()
            .responseDecodable(of: T.self) { response in
                let responseData = HttpResponse(response)
                responseData.continueCheckResponse(continuation)
            }
        }
    }
    
    static func post<T: Codable>(
        _ url: String,
        json: [String: Any]? = nil,
        headers: [String: String]? = nil) async throws -> T
    {
        return try await withCheckedThrowingContinuation { continuation in
            let reqHeaders = HttpHeader(headers)
            AF.request(
                url,
                method: .post,
                parameters: json,
                encoding: JSONEncoding.default,
                headers: reqHeaders.getHeaders())
            .validate()
            .responseDecodable(of: T.self) { response in
                let responseData = HttpResponse(response)
                responseData.continueCheckResponse(continuation)
            }
        }
    }
    
    static func post<T: Codable, Parameter: Codable>(
        _ url: String,
        json: Parameter,
        headers: [String: String]? = nil) async throws -> T
    {
        return try await withCheckedThrowingContinuation { continuation in
            let reqHeaders = HttpHeader(headers)
            AF.request(
                url,
                method: .post,
                parameters: json,
                encoder: JSONParameterEncoder.default,
                headers: reqHeaders.getHeaders())
            .validate()
            .responseDecodable(of: T.self) { response in
                let responseData = HttpResponse(response)
                responseData.continueCheckResponse(continuation)
            }
        }
    }
    
    static func put<T: Codable>(
        _ url: String,
        json: [String: Any]? = nil,
        headers: [String: String]? = nil) async throws -> T
    {
        return try await withCheckedThrowingContinuation { continuation in
            let reqHeaders = HttpHeader(headers)
            AF.request(
                url,
                method: .put,
                parameters: json,
                encoding: JSONEncoding.default,
                headers: reqHeaders.getHeaders())
            .validate()
            .responseDecodable(of: T.self) { response in
                let responseData = HttpResponse(response)
                responseData.continueCheckResponse(continuation)
            }
        }
    }
    
    static func put<T: Codable, Parameter: Codable>(
        _ url: String,
        json: Parameter,
        headers: [String: String]? = nil) async throws -> T
    {
        return try await withCheckedThrowingContinuation { continuation in
            let reqHeaders = HttpHeader(headers)
            AF.request(
                url,
                method: .put,
                parameters: json,
                encoder: JSONParameterEncoder.default,
                headers: reqHeaders.getHeaders())
            .validate()
            .responseDecodable(of: T.self) { response in
                let responseData = HttpResponse(response)
                responseData.continueCheckResponse(continuation)
            }
        }
    }
    
    static func delete<T: Codable>(
        _ url: String,
        json: [String: Any]? = nil,
        headers: [String: String]? = nil) async throws -> T
    {
        return try await withCheckedThrowingContinuation { continuation in
            let reqHeaders = HttpHeader(headers)
            AF.request(
                url,
                method: .delete,
                parameters: json,
                encoding: JSONEncoding.default,
                headers: reqHeaders.getHeaders())
            .validate()
            .responseDecodable(of: T.self) { response in
                let responseData = HttpResponse(response)
                responseData.continueCheckResponse(continuation)
            }
        }
    }
    
    static func uploadFile<T: Codable>(
        _ url: String,
        fileUrl: URL,
        fileKey: String,
        params: [String: Any]? = nil,
        headers: [String: String]? = nil,
        progressHandler: @escaping (_ progress: Double) -> Void = { progress in }) async throws -> T
    {
        return try await withCheckedThrowingContinuation { continuation in
            let reqHeaders = HttpHeader(
                requiredHeaders: [
                    "Content-type": "multipart/form-data"
                ],
                optionalHeaders: headers)
            
            var encodedURLString: String? = nil
            if params != nil {
                let urlWithQuery = url + "?" + params!.map{"\($0.key)=\($0.value)" }.joined(separator: "&")
                encodedURLString = urlWithQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            }
            
            AF.upload(
                multipartFormData: { formData in
                    formData.append(fileUrl, withName: fileKey)
                },
                to: encodedURLString ?? url,
                headers: reqHeaders.getHeaders())
            .uploadProgress(closure: { progress in
                progressHandler(progress.fractionCompleted)
            })
            .responseDecodable(of: T.self) { response in
                let responseData = HttpResponse(response)
                responseData.continueCheckResponse(continuation)
            }
        }
    }
    
    static func postStreamString<T: Encodable>(
        _ url: String,
        json: [String: T]? = nil,
        headers: [String: String]? = nil) -> AsyncStream<String>
    {
        return AsyncStream { continuation in
            let reqHeaders = HttpHeader(headers)
            AF.streamRequest(
                url,
                method: .post,
                parameters: json,
                encoder: JSONParameterEncoder.json,
                headers: reqHeaders.getHeaders()
            )
            .validate()
            .responseStreamString { stream in
                switch stream.event {
                case let .stream(result):
                    switch result {
                    case let .success(data):
                        continuation.yield(data)
                    }
                case let .complete(completion):
                    continuation.finish()
                }
            }
        }
    }
    
    static func downloadFile(_ url: String) -> AsyncStream<(Bool, Double, Data?)> {
        guard let downloadUrl = URL(string: url) else {
            return AsyncStream<(Bool, Double, Data?)> { continuation in
                continuation.finish()
            }
        }
        
        return AsyncStream { continuation in
            AF.download(downloadUrl)
                .downloadProgress { progress in
                    continuation.yield((false, progress.fractionCompleted, nil))
                }
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        continuation.yield((true, 1, data))
                        continuation.finish()
                    case .failure(let error):
                        continuation.finish()
                    }
                }
        }
    }
}
