//
//  ByteBackgroundImage.swift
//  Bythen
//
//  Created by edisurata on 29/09/24.
//

import Foundation

struct ByteBackgroundImage: Codable, Identifiable {
    let id = UUID()
    
    var bgImageID: Int64 = 0
    @DefaultEmptyString var imageUrl: String = ""
    @DefaultZeroInt64 var accountID: Int64 = 0
    
    enum CodingKeys: String, CodingKey {
        case bgImageID = "id"
        case imageUrl = "image_url"
        case accountID = "account_id"
    }
}
