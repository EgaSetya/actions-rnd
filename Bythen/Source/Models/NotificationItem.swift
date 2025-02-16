//
//  NotificationItem.swift
//  Bythen
//
//  Created by Darul Firmansyah on 06/02/25.
//

import Foundation

struct NotificationItem: Codable {
    let id: Int
    let accountId: Int
    let message: String
    let group: NotificationListFilter
    let createdAt: Date
    let notificationInterval: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case accountId = "account_id"
        case message
        case group
        case createdAt = "created_at"
        case notificationInterval = "notification_interval"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        accountId = try container.decode(Int.self, forKey: .accountId)
        message = try container.decode(String.self, forKey: .message)
        group = try container.decode(NotificationListFilter.self, forKey: .group)
        notificationInterval = try container.decode(Int.self, forKey: .notificationInterval)
        
        let dateString = try container.decode(String.self, forKey: .createdAt)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .createdAt, in: container, debugDescription: "Invalid date format")
        }
        createdAt = date
    }
}
