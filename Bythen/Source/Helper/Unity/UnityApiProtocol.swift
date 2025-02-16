//
//  UnityApiProtocol.swift
//  Bythen
//
//  Created by edisurata on 19/09/24.
//

import Foundation

enum UnityProductType: Int {
    case collection = 0
    case chatroom = 1
    case studio = 2
}

protocol UnityApiProtocol {
    
    func setAvatar(avatarID: String)
    
    func startAvatarAnimation()
    
    func stopAvatarAnimation()
    
    func triggerAvatarVoice(_ voice: String, emotion: String, voiceID: String, voicePitch: Int64)
    
    func setBackgroundColor(hexColorString: String)
    
    func stopGenerate()
    
    func changeAvatarTraits(_ traits: String)
    
    func startAvatar(_ traits: String)
    
    func stopAvatar()
    
    func prepareAvatar()
    
    func setBackgroundImage(imageUrl: String)
    
    func endChatResponse()
    
    func changeProductType(productType: UnityProductType)
    
    func hideCharacter(delay: Float)
    
    func showCharacter(delay: Float)
    
    func changeTheme(theme: Int)
    
    func setTalkingSpeed(value: Float)
    
    func requestAudio(voiceID: String, voicePitch: Int64, voiceTexts: [String])
    
    func startRecord()
}
