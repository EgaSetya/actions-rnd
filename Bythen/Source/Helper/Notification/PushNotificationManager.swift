//
//  PushNotificationManager.swift
//  Bythen
//
//  Created by Ega Setya on 17/01/25.
//

import SwiftUI

enum PushNotificationAction: String {
    case openHive = "open_hive"
    case openStore = "open_store"
    case openNotifications = "open_notifications"
}

class PushNotificationManager: ObservableObject {
    @Published var action: PushNotificationAction?
    
    func handleNotificationRedirection(from userInfo: [String: Any]) {
        guard let action = extractAction(from: userInfo),
              let notificationAction = PushNotificationAction(rawValue: action)
        else {
            return
        }
        
        switch notificationAction {
        case .openStore:
            if let storeURL = URL(string: AppConfig.storeUrl),
               UIApplication.shared.canOpenURL(storeURL) {
                UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
            }
        default:
            self.action = notificationAction
        }
    }
    
    private func extractAction(from userInfo: [AnyHashable: Any]) -> String? {
        return userInfo["action"] as? String
    }
}
