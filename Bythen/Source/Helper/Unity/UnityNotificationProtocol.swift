//
//  UnityNotificationProtocol.swift
//  Bythen
//
//  Created by edisurata on 19/09/24.
//

import Foundation
import Combine

protocol UnityNotificationProtocol {
    var appLoadedSignal: PassthroughSubject<String, Never> { get }
    var avatarStartTalkingSignal: NotificationCenter.Publisher? { get }
    var avatarEndTalkingSignal: NotificationCenter.Publisher? { get }
    var loadingScreenShowedSignal: NotificationCenter.Publisher? { get }
    var loadingScreenHiddenSignal: NotificationCenter.Publisher? { get }
    var voicePlayedSignal: NotificationCenter.Publisher? { get }
    var audioReadySignal: NotificationCenter.Publisher? { get }
}
