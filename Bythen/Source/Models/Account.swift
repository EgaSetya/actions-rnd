//
//  Account.swift
//  Bythen
//
//  Created by edisurata on 30/08/24.
//

import Foundation
import BetterCodable

struct Account: Codable {
    @DefaultFalse var isProfileCompleted: Bool = false
    @DefaultZeroInt64 var accountID: Int64 = 0
    @DefaultEmptyString var accessToken: String
    @DefaultEmptyString var accountType: String
    @DefaultEmptyString var username: String
    @DefaultEmptyString var email: String
    @DefaultEmptyString var telegramUsername: String
    @DefaultEmptyString var discordUsername: String
    @DefaultEmptyString var twitterUsername: String
    var walletAddress: String?
    var aggreementApprovedAt: String?
    @DefaultEmptyString var profileImageUrl: String = ""
    @DefaultZeroInt64 var loginAccountID: Int64 = 0
    
    @DefaultEmptyString var name: String = ""
    @DefaultEmptyString var referralCode: String = ""
    
    @DefaultFalse var hasHive: Bool
    @DefaultFalse var isTester: Bool
    
    var adjustedProfileImageUrl: String {
        if profileImageUrl.isTrulyEmpty {
            return accountID.createDefaultImageReplacementURL()
        }
        
        return profileImageUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case accountID = "id"
        case accessToken = "access_token"
        case accountType = "account_type"
        case walletAddress = "wallet_public_key"
        case aggreementApprovedAt = "agreement_approved_at"
        case name
        case username
        case profileImageUrl = "profile_image_url"
        case referralCode = "referral_code"
        case telegramUsername = "telegram_username"
        case discordUsername = "discord_username"
        case twitterUsername = "twitter_username"
        case isProfileCompleted = "is_profile_completed"
        case loginAccountID = "account_id"
        case email = "email"
        case hasHive = "has_hive"
        case isTester = "is_tester"
    }
}
