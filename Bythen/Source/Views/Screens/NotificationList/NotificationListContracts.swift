//
//  NotificationListContracts.swift
//  Bythen
//
//  Created by Darul Firmansyah on 06/02/25.
//

enum NotificationListFilter: String, Codable, CaseIterable {
    case all
    case hive = "hive"
    case mission = "mission"
    
    var stringRepresentable: String {
        switch self {
        case .hive:
            "Hive".uppercased()
        case .mission:
            "Mission".uppercased()
        case .all:
            "All".uppercased()
        }
    }
    
    init(from decoder: Decoder) throws {
        self = try NotificationListFilter(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .all
    }
}

enum NotificationListPageState {
    case initialLoading
    case paginationLoading
    case idle
    case empty
}
