//
//  Pagination.swift
//  Bythen
//
//  Created by Darul Firmansyah on 23/01/25.
//

struct Pagination: Codable {
    let totalPage: Int
    var totalRecord: Int?
    let page: Int
    let limit: Int
    let nextPage: Int?
    let prevPage: Int?

    enum CodingKeys: String, CodingKey {
        case totalPage = "total_page"
        case totalRecord = "total_record"
        case page
        case limit
        case nextPage = "next_page"
        case prevPage = "prev_page"
    }
}
