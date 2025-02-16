//
//  analytic_service.swift
//  Bythen
//
//  Created by edisurata on 20/11/24.
//

import Foundation
import FirebaseAnalytics

enum TrackingLoginMethod: String {
    case manual
    case force
}

protocol AnalyticServiceProtocol {
    func trackDLU(accountID: Int64) async throws
    func trackPageView(page: String, className: String, params: [String: Any]?)
    func trackLogin(accountID: Int64)
    func trackLogout(method: TrackingLoginMethod)
    func trackClickEvent(button_name: String, value: Any?)
    func trackEvent(eventName: String, params: [String: Any]?)
}

class AnalyticService: AnalyticServiceProtocol {
    let kCustomParameterKey1 = "parameter_1"
    let kCustomParameterKey2 = "parameter_2"
    let kCustomParameterKey3 = "parameter_3"
    
    static let shared: AnalyticServiceProtocol = AnalyticService()
    
    func trackDLU(accountID: Int64) async throws {
        #if STAGING || PRODUCTION
        let _: EmptyBody = try await Http.post("\(AppConfig.analyticBaseUrl)/analytics-dlu", json: ["account_id": accountID, "platform": "ios"])
        #endif
    }
    
    func trackPageView(page: String, className: String, params: [String: Any]? = nil) {
        #if STAGING || PRODUCTION
        var requiredParams: [String: Any] = [
            AnalyticsParameterScreenName: page,
            AnalyticsParameterScreenClass: className
        ]
        
        if let params = params {
            requiredParams.merge(params) { (old, new) in old }
        }
        
        Analytics.logEvent(
            AnalyticsEventScreenView,
            parameters: requiredParams
        )
        #endif
    }
    
    func trackLogin(accountID: Int64) {
        #if STAGING || PRODUCTION
        Analytics.setUserID("\(accountID)")
        
        Analytics.logEvent("login", parameters: [
            "Method": "connect_wallet"
        ])
        #endif
    }
    
    func trackLogout(method: TrackingLoginMethod = .manual) {
        #if STAGING || PRODUCTION
        Analytics.setUserID(nil)
        
        Analytics.logEvent("logout", parameters: [
            "Method": method.rawValue
        ])
        #endif
    }
    
    func trackClickEvent(button_name: String, value: Any?) {
        #if STAGING || PRODUCTION
        var requiredParams: [String: Any] = [kCustomParameterKey1: button_name]
        if let value {
            requiredParams[kCustomParameterKey2] = value
        }
        Analytics.logEvent("button_click", parameters: requiredParams)
        #endif
    }
    
    func trackEvent(eventName: String, params: [String: Any]? = nil) {
        #if STAGING || PRODUCTION
        Analytics.logEvent(eventName, parameters: params)
        #endif
    }
}
