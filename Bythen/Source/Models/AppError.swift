//
//  AppError.swift
//  Bythen
//
//  Created by edisurata on 17/09/24.
//

import Foundation

protocol BaseError: Error {
    var code: Int { get }
    var message: String { get }
}

struct AppError: Error {
    var code: Int
    var message: String
}
