//
//  PushNotification.swift
//  Bythen
//
//  Created by edisurata on 12/09/24.
//

import SwiftUI
import UserNotifications

import FirebaseCore
import FirebaseMessaging
import FirebasePerformance

class BythenAppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    weak var pushNotificationManager: PushNotificationManager?
    
    static func setViewOrientation(orientation: UIInterfaceOrientationMask) {
        if orientationLock == orientation { return }
        DispatchQueue.main.async {
            BythenAppDelegate.orientationLock = orientation
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
       }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        setupFirebase()
        
        setupPusNotification()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        NotificationHelper.shared.savePushNotificationsToken(tokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        debugPrint("Failed to register for push notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return BythenAppDelegate.orientationLock
    }
    
    private func setupPusNotification() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Permission denied: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        Messaging.messaging().delegate = self
    }
    
    private func setupFirebase() {
        if let filePath = Bundle.main.path(forResource: AppConfig.googleServiceInfoPlist, ofType: "plist"),
           let options = FirebaseOptions(contentsOfFile: filePath) {
            Logger.logInfo("configure firebase with \(AppConfig.googleServiceInfoPlist).plist")
            FirebaseApp.configure(options: options)
            RemoteConfigProvider.shared.fetchCloudValues()
        } else {
            Logger.logInfo("Could not find \(AppConfig.googleServiceInfoPlist).plist")
        }
        
        Performance.sharedInstance().isInstrumentationEnabled = true
        Performance.sharedInstance().isDataCollectionEnabled = true
    }
}

extension BythenAppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String: Any] {
            pushNotificationManager?.handleNotificationRedirection(from: userInfo)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .list, .sound])
    }
}

extension BythenAppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            NotificationHelper.shared.savePushNotificationsToken(token)
        }
    }
}
