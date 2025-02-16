//
//  to.swift
//  Bythen
//
//  Created by Ega Setya on 19/12/24.
//

import FirebaseRemoteConfig

/**
 Provider for communicate with firebase remote configs and fetch config values
 */
final class RemoteConfigProvider {
    static let shared = RemoteConfigProvider()
    
    private var loadingDoneCallback: (() -> Void)?
    private var fetchComplete = false
    private var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    private var remoteConfig = RemoteConfig.remoteConfig()
    
    private init() {
        setupConfigs()
        loadFeatureFlagDefaultValues()
        loadStringRepositoryDefaultValues()
        setupListener()
    }
    
    /**
         Function for fectch values from the cloud
     */
    func fetchCloudValues() {
        remoteConfig.fetch { [weak self] (status, error) -> Void in
            guard let self = self else { return }
            
            if status == .success {
                self.remoteConfig.activate { _, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    self.fetchComplete = true
                    print("Remote config fetch success")
                    DispatchQueue.main.async {
                        self.loadingDoneCallback?()
                    }
                }
            } else {
                print("Remote config fetch failed")
                DispatchQueue.main.async {
                    self.loadingDoneCallback?()
                }
            }
        }
    }
    
    func isFeatureEnabled(for featureFlagKey: String) -> Bool {
        return remoteConfig[featureFlagKey].boolValue
    }
    
    func getStringValue(for remoteConfigKey: String) -> String {
        return remoteConfig[remoteConfigKey].stringValue
    }
}

// MARK: Private functions
extension RemoteConfigProvider {
    private func setupConfigs() {
        let settings = RemoteConfigSettings()
        // fetch interval that how frequent you need to check updates from the server
        settings.minimumFetchInterval = isDebug ? 0 : 43200
        remoteConfig.configSettings = settings
    }
    
    private func loadFeatureFlagDefaultValues() {
        remoteConfig.setDefaults(FeatureFlag.defaultValues as [String: NSObject])
    }
    
    private func loadStringRepositoryDefaultValues() {
        remoteConfig.setDefaults(StringRepository.defaultValues as [String: NSObject])
    }
    
    /**
     Setup listner functions for frequent updates
     */
    private func setupListener() {
        remoteConfig.addOnConfigUpdateListener { configUpdate, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard configUpdate != nil else {
                print("REMOTE CONFIG ERROR")
                return
            }
            
            self.remoteConfig.activate { changed, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("REMOTE CONFIG activation state change \(changed)")
                }
            }
        }
    }
}
