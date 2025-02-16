//
//  AppSession.swift
//  Bythen
//
//  Created by edisurata on 25/09/24.
//

import Foundation

protocol AppSessionProtocol {
    func setCurrentAccount(account: Account)
    func getCurrentAccount() -> Account?
    func removeCurrentUser()
    func hasAcceptedTermsOfService() -> Bool
    func setAcceptedTermsOfService(_ accepted: Bool)
    func getTrial() -> FreeTrial?
    func setTrial(_ trial: FreeTrial)
    func setAuthToken(authToken: String)
    func getAuthToken() -> String?
    func setLastTraits(_ traits: String)
    func getLastTraits() -> String?
}

class AppSession: AppSessionProtocol {
    static let shared : AppSession = AppSession()
    
    enum storeKey: String {
        case authToken = "auth_token"
        case currentAccount = "current_account"
        case termsOfServiceAgreementStatus = "terms_of_service_agreement_status"
        case trial = "trial"
        case lastTraits = "last_traits"
        case showHiveGreeting = "show_hive_greeting"
    }
    
    func setAuthToken(authToken: String) {
        LocalStorage.setValueObject(authToken, key: storeKey.authToken.rawValue)
    }
    
    func getAuthToken() -> String? {
        return LocalStorage.getValueObject(storeKey.authToken.rawValue)
    }
    
    func setCurrentAccount(account: Account) {
        LocalStorage.setValueObject(account, key: storeKey.currentAccount.rawValue)
    }
    
    func getCurrentAccount() -> Account? {
        return LocalStorage.getValueObject(storeKey.currentAccount.rawValue)
    }
    
    func removeCurrentUser() {
        LocalStorage.removeValue(storeKey.currentAccount.rawValue)
        LocalStorage.removeValue(storeKey.termsOfServiceAgreementStatus.rawValue)
        LocalStorage.removeValue(storeKey.trial.rawValue)
        LocalStorage.removeValue(storeKey.authToken.rawValue)
        LocalStorage.removeValue(storeKey.showHiveGreeting.rawValue)
        LocalStorage.removeValue(storeKey.lastTraits.rawValue)
    }
    
    func hasAcceptedTermsOfService() -> Bool {
        return LocalStorage.getValueObject(storeKey.termsOfServiceAgreementStatus.rawValue) ?? false
    }
    
    func setAcceptedTermsOfService(_ accepted: Bool) {
        LocalStorage.setValueObject(accepted, key: storeKey.termsOfServiceAgreementStatus.rawValue)
    }
    
    func getTrial() -> FreeTrial? {
        return LocalStorage.getValueObject(storeKey.trial.rawValue)
    }
    
    func setTrial(_ trial: FreeTrial) {
        LocalStorage.setValueObject(trial, key: storeKey.trial.rawValue)
    }
    
    func setLastTraits(_ traits: String) {
        LocalStorage.setValueObject(traits, key: storeKey.lastTraits.rawValue)
    }
    
    func getLastTraits() -> String? {
        return LocalStorage.getValueObject(storeKey.lastTraits.rawValue)
    }
    
    func markHiveGreetingAsShown() {
        LocalStorage.setBool(true, key: storeKey.showHiveGreeting.rawValue)
    }
    
    func shouldShowHiveGreeting() -> Bool {
        !LocalStorage.getBool(storeKey.showHiveGreeting.rawValue)
    }
}
