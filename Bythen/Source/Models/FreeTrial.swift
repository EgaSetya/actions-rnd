//
//  FreeTrial.swift
//  Bythen
//
//  Created by edisurata on 07/11/24.
//

import Foundation

struct FreeTrial: Codable {
    var currentTime: String = ""
    var trialEndedAt: String = ""
    var trialCountdown: Int64 = 0
    var originalTokenID: Int64 = 0
    var originalTokenSymbol: String = ""
    var isTrialFinished: Bool = false
    var isEndDialogueDisplayed: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case currentTime = "current_time"
        case trialEndedAt = "trial_ended_at"
        case trialCountdown = "trial_countdown"
        case originalTokenID = "original_token_id"
        case originalTokenSymbol = "original_token_symbol"
        case isTrialFinished = "is_trial_finished"
        case isEndDialogueDisplayed = "is_end_dialogue_displayed"
    }
    
    func isTrialActive() -> Bool {
        return originalTokenID > 0 && originalTokenSymbol != ""
    }
}
