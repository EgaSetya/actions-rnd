//
//  HiveProduct.swift
//  Bythen
//
//  Created by Darindra R on 09/12/24.
//

struct HiveProductResponse: Codable {
    let products: [HiveProduct]
}

struct HiveProduct: Codable {
    let id: Int
    let tokenID: Int
    let address: String
    let updatedAt: String
    let data: HiveProductData

    enum CodingKeys: String, CodingKey {
        case id
        case tokenID = "token_id"
        case address = "owner_address"
        case updatedAt = "updated_at"
        case data = "product"
    }
}

struct HiveProductData: Codable {
    let id: Int
    let slug: String
    let slot: Int
    let iconURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case slot
        case iconURL = "icon_url"
    }
}
