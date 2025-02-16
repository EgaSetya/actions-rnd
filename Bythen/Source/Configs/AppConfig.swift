//
//  AppConfig.swift
//  Bythen
//
//  Created by edisurata on 28/08/24.
//

import Foundation

class AppConfig {
    static let appGroupIdentifier = "group.ai.bythen.bythenapp"
    static let sentryDsn = "https://337a7100b3115352958819ae1392fa96@o4506953589522432.ingest.us.sentry.io/4507807449153536"
    
    #if DEV || STAGING
    static let apiBaseUrl = "https://api-staging.bythen.ai"
    static let walletConnectProjectID = "ac50d5e0d9cd0c2f2b330ca14bc40dcf"
    static let staticAssetsBaseUrl = "https://assets-staging.bythen.ai"
    static let sentryEnv = "dev"
    static let featureFlagsUrl = "https://assets-staging.bythen.ai/feature-flags/staging/ios/bythen-app.json"
    static let storeUrl = "https://staging.bythen.ai/store"
    static let unityEnv = "staging"
    static let analyticBaseUrl = "https://us-central1-tanooki-staging.cloudfunctions.net"
    static let googleServiceInfoPlist = "GoogleService-Info-dev"
    static let webBaseURL = "https://staging.bythen.ai"
    #else
    static let apiBaseUrl = "https://api.bythen.ai"
    static let walletConnectProjectID = "0a641fac38e2a9a674d06583b576349b"
    static let staticAssetsBaseUrl = "https://assets.bythen.ai"
    static let sentryEnv = "production"
    static let featureFlagsUrl = "https://assets.bythen.ai/feature-flags/ios/bythen-app.json"
    static let storeUrl = "https://bythen.ai/store"
    static let unityEnv = "production"
    static let analyticBaseUrl = "https://us-central1-bythen-production.cloudfunctions.net"
    static let googleServiceInfoPlist = "GoogleService-Info-prod"
    static let webBaseURL = "https://www.bythen.ai"
    #endif
    
    #if DEV
    static let ff: [String: Bool] = [
        "login_with_email": true,
        "account_setup": true,
        "hive": true
    ]
    #endif
    
}
