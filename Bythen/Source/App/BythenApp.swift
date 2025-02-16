//
//  BythenApp.swift
//  Bythen
//
//  Created by edisurata on 28/08/24.
//

import SwiftUI
//import Sentry

enum AppPage {
    case chat
    case mycollection
}

@main
struct BythenApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: BythenAppDelegate
    @State var showUpdateAlert: Bool = false
    
    @StateObject var pushNotificationManager = PushNotificationManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if !showUpdateAlert {
                    MainView()
                        .environmentObject(pushNotificationManager)
                }
                
                if showUpdateAlert {
                    AlertView(
                        didDismiss: {},
                        title: "App Needs Update",
                        content: "A new version of the app is available. Please update to continue.",
                        actionTitle: "Update",
                        action: {
                            openAppStore()
                        },
                        disableDismiss: true
                    )
                }
            }
            .onAppear(perform: {
                setupPushNotificationManager()
                UnityApp.initializeUnityApp()
                setupWalletConnect()
//                setupSentry()
                checkForUpdate()
                UnityApi.shared.setupEnvironment(env: AppConfig.unityEnv)
            })
        }
    }
    
    private func setupWalletConnect() {
        Task {
            WalletConnect.shared.setup()
            WalletConnect.shared.startListenToPublisher()
        }
    }
    
//    private func setupSentry() {
//        SentrySDK.start { options in
//            options.dsn = AppConfig.sentryDsn
//            options.debug = false
//            options.tracesSampleRate = 1
//            options.environment = AppConfig.sentryEnv
//            options.beforeSend = { event in
//                if let exception = event.exceptions?.first {
//                    let value = exception.value
//                    if value.contains("ShakeGestureViewController") {
//                        return nil
//                    }
//                }
//                return event
//            }
//        }
//    }
    
    private func checkForUpdate() {
        Task { @MainActor in
            let staticService = StaticAssetsService()
            let resp: [String: String] = try await staticService.getAssets(path: .appVersion)
            
            if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let minVersion = resp["minimum_version"] {
                if currentVersion < minVersion {
                    showUpdateAlert = true
                }
            }
        }
    }
    
    private func openAppStore() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/6670246602") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func setupPushNotificationManager() {
        appDelegate.pushNotificationManager = pushNotificationManager
    }
}
