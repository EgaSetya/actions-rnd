//
//  HttpHeaders.swift
//  Bythen
//
//  Created by edisurata on 30/08/24.
//

import Foundation
import Alamofire
import Foundation

class HttpHeader {
    var headers: [String: String]?

    init(_ headers: [String: String]? = nil) {
        self.headers = headers
    }

    init(requiredHeaders: [String: String], optionalHeaders: [String: String]?) {
        if let headers = optionalHeaders {
            self.headers = requiredHeaders.merging(headers) { current, _ in current }
        } else {
            headers = requiredHeaders
        }
    }

    func getHeaders() -> HTTPHeaders? {
        var afHeaders: HTTPHeaders?
        if let header = headers {
            afHeaders = HTTPHeaders(header)
        }

        return afHeaders
    }
}
