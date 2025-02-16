//
//  Notifications.swift
//  Bythen
//
//  Created by Ega Setya on 07/01/25.
//

import Foundation

class NotificationHelper: BythenApi {
    static let shared = NotificationHelper()
    
    private let localStorageKey = "PushNotificationToken"
    private let service = NotificationService()
    
    func savePushNotificationsToken(_ token: String) {
        LocalStorage.setValueString(token, key: localStorageKey)
        
        if let _ = AppSession.shared.getCurrentAccount()?.accessToken {
            registerPushNotification()
        }
    }
    
    func registerPushNotification() {
        Task {
            let pushNotificationToken = LocalStorage.getValueString(localStorageKey) ?? ""
            try await service.registerNotification(for: pushNotificationToken)
        }
    }
    
    func getNotificationRedDot() async -> Bool {
        do {
            let response: NoficationMarkResponse = try await service.getNotificationMark()
            return response.hasNewNotification
        } catch {
            return false
        }
    }
}

struct NoficationMarkResponse: Codable {
    var hasNewNotification: Bool
    enum CodingKeys: String, CodingKey {
        case hasNewNotification = "has_new_notification"
    }
}
