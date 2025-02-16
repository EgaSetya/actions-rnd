//
//  UnityNotification.swift
//  Bythen
//
//  Created by edisurata on 06/09/24.
//

import Foundation
import Combine

enum UnityEventSignal {
    case startTalking, endTalking, appLoaded, loadingScreenShowed, loadingScreenHidden, voicePlayedSignal, audioReadySingal
    
    func getNotificationName() -> Notification.Name {
        switch self {
        case .startTalking: return NSNotification.Name("SignalStartTalking")
        case .endTalking: return NSNotification.Name("SignalEndTalking")
        case .appLoaded: return NSNotification.Name("SignalAppLoaded")
        case .loadingScreenShowed: return NSNotification.Name("SignalShowLoadingScreen")
        case .loadingScreenHidden: return NSNotification.Name("SignalHideLoadingScreen")
        case .voicePlayedSignal: return NSNotification.Name("SignalVoicePlayed")
        case .audioReadySingal: return NSNotification.Name("SignalStudioAudioReady")
        }
    }
}

class UnityNotification: UnityNotificationProtocol {
    static let shared = UnityNotification()
    
    var appLoadedSignal = PassthroughSubject<String, Never>()
    var avatarStartTalkingSignal: NotificationCenter.Publisher?
    var avatarEndTalkingSignal: NotificationCenter.Publisher?
    var loadingScreenShowedSignal: NotificationCenter.Publisher?
    var loadingScreenHiddenSignal: NotificationCenter.Publisher?
    var voicePlayedSignal: NotificationCenter.Publisher?
    var audioReadySignal: NotificationCenter.Publisher?
    
    private init() {
        registerNotifications()
    }
    
    private func registerNotifications() {
        avatarStartTalkingSignal = NotificationCenter.default.publisher(for: UnityEventSignal.startTalking.getNotificationName())
        avatarEndTalkingSignal = NotificationCenter.default.publisher(for: UnityEventSignal.endTalking.getNotificationName())
        loadingScreenShowedSignal = NotificationCenter.default.publisher(for: UnityEventSignal.loadingScreenShowed.getNotificationName())
        loadingScreenHiddenSignal = NotificationCenter.default.publisher(for: UnityEventSignal.loadingScreenHidden.getNotificationName())
        voicePlayedSignal = NotificationCenter.default.publisher(for: UnityEventSignal.voicePlayedSignal.getNotificationName())
        audioReadySignal = NotificationCenter.default.publisher(for: UnityEventSignal.audioReadySingal.getNotificationName())
    }
}
