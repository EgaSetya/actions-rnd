//
//  StringRepository.swift
//  Bythen
//
//  Created by Ega Setya on 24/01/25.
//

enum StringRepository: String, CaseIterable {
    case hiveShareReferralText = "hive_referral_share_message"
    case hiveReferralHeaderCopy = "hive_referral_header_copy"
    case hiveReferralSubheaderCopy = "hive_referral_subheader_copy"
    case hiveReferralFooterCopy = "hive_referral_footer_copy"
    case hiveWithdrawalRules = "hive_withdrawal_rules"
    case whitelistUserIds = "whitelist_user_id"
    case hiveLeaderboardRules = "hive_leaderboard_rules"
    
    static var defaultValues: [String: String] {
        return Dictionary<String, String>(uniqueKeysWithValues: StringRepository.allCases.map { key in
            switch key {
            case .hiveShareReferralText:
                return (key.rawValue, "Hi, you're invited to join Bytes Hive! 🐝 Use {referralCode} to enjoy a 5% discount on your first purchase and unlock exciting rewards.")
            case .hiveReferralHeaderCopy:
                return (key.rawValue, "Start Earning Today—Don’t Miss Out!")
            case .whitelistUserIds:
                return (key.rawValue, "68913, 231691")
            default:
                return (key.rawValue, "")
            }
        })
    }
}

extension StringRepository {
    func getString() -> String {
        RemoteConfigProvider.shared.getStringValue(for: self.rawValue)
    }
}
