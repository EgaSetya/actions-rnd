//
//  FeatureFlagKey.swift
//  Bythen
//
//  Created by Ega Setya on 19/12/24.
//


/**
 Use this enum to refer the variables that you need to fetch and control remotely
 from Firebase Remote config console.
 */
enum FeatureFlag: String, CaseIterable {
    case profilePage = "my_account_profile"
    case loginWithEmail = "login_with_email"
    case accountSetup = "account_setup"
    case hive = "hive"
    case hiveAfterLogin = "hive_after_login"
    case sideMenuMission = "side_menu_mission"
    case releaseHive = "release_hive"
    case releaseHiveAfterLogin = "release_hive_after_login"
    case sideMenuAppVersion = "side_menu_app_version"
    case studioRecordImprovement = "studio_record_improvement"
    case sideMenuNotification = "side_menu_notification_list"
    case withdrawal = "app_withdrawal"
    
    /// A dictionary of default values for all feature flags.
    ///
    /**
     In case firebase failed to fetch values from the remote server due to internet failure
     or any other circumstance, In order to run our application without any issues
     we have to set default values for all the variables that we fetches
     from the remote server.
     If you have higher number of variables in use, you can use info.plist file
     to define the defualt values as well.
     */
    static var devDefaultValues: [String: Bool] {
        return Dictionary(uniqueKeysWithValues: FeatureFlag.allCases.map { feature in
            switch feature {
            case .profilePage: (feature.rawValue, true)
            case .loginWithEmail: (feature.rawValue, true)
            case .accountSetup: (feature.rawValue, true)
            case .hive: (feature.rawValue, true)
            case .hiveAfterLogin: (feature.rawValue, true)
            case .sideMenuMission: (feature.rawValue, true)
            case .releaseHive: (feature.rawValue, true)
            case .releaseHiveAfterLogin: (feature.rawValue, true)
            case .sideMenuAppVersion: (feature.rawValue, true)
            case .studioRecordImprovement: (feature.rawValue, true)
            case .sideMenuNotification: (feature.rawValue, true)
            case .withdrawal: (feature.rawValue, true)
            }
        })
    }
    
    static var defaultValues: [String: Bool] {
        return Dictionary(uniqueKeysWithValues: FeatureFlag.allCases.map { feature in
            switch feature {
            case .profilePage: (feature.rawValue, true)
            case .loginWithEmail: (feature.rawValue, true)
            case .accountSetup: (feature.rawValue, true)
            case .hive: (feature.rawValue, false)
            case .hiveAfterLogin: (feature.rawValue, false)
            case .sideMenuMission: (feature.rawValue, false)
            case .releaseHive: (feature.rawValue, false)
            case .releaseHiveAfterLogin: (feature.rawValue, false)
            case .sideMenuAppVersion: (feature.rawValue, false)
            case .studioRecordImprovement: (feature.rawValue, false)
            case .sideMenuNotification: (feature.rawValue, false)
            case .withdrawal: (feature.rawValue, false)
            }
        })
    }
}

extension FeatureFlag {
    /// Check if the feature flag is enabled.
    ///
    /// - Returns: A boolean indicating whether the feature flag is enabled.
    func isFeatureEnabled() -> Bool {
        guard !isWhitelistUser() else {
            return true
        }
        
        #if DEV || STAGING
        return FeatureFlag.devDefaultValues[self.rawValue] ?? false
        #else
        return RemoteConfigProvider.shared.isFeatureEnabled(for: self.rawValue)
        #endif
    }
    
    private func isWhitelistUser() -> Bool {
        let whiteListUserIds = StringRepository.whitelistUserIds.getString().components(separatedBy: ",").compactMap { Int64($0) }
        
        return whiteListUserIds.contains(AppSession.shared.getCurrentAccount()?.accountID ?? 0)
    }
}
