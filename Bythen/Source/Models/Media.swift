//
//  Media.swift
//  Bythen
//
//  Created by Ega Setya on 16/12/24.
//


// MARK: - Media
struct Media: Codable {
    let filename, originalFilename: String
    let size: Int
    let type, url: String

    enum CodingKeys: String, CodingKey {
        case filename
        case originalFilename = "original_filename"
        case size, type, url
    }
}