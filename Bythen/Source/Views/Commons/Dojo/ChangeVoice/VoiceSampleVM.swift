//
//  VoiceSampleVM.swift
//  Bythen
//
//  Created by edisurata on 14/10/24.
//

import Foundation

class VoiceSampleVM: BaseViewModel {
    @Published var isSelected: Bool = false
    @Published var name: String = ""
    @Published var voiceSampleUrl: String = ""
    @Published var isPlayingAudio: Bool = false
    @Published var voicePowers: [Double] = [0.0, 0.0, 0.0]
    var voiceID: Int64 = 0
    var selectVoiceAction: (_ voice: Voice, _ selection: VoiceSampleVM) -> Void
    var slug: String = ""
    private var voice: Voice
    
    init(voice: Voice, isSelected: Bool = false, selectVoiceAction: @escaping (_ voice: Voice, _ selection: VoiceSampleVM) -> Void) {
        self.voice = voice
        self.voiceID = voice.voiceID
        self.slug = voice.slug
        self.name = voice.displayName.uppercased()
        self.voiceSampleUrl = voice.voiceSampleUrl
        self.isSelected = isSelected
        self.selectVoiceAction = selectVoiceAction
    }
    
    func tapAction() {
        if self.isSelected {
            return
        }
        self.isSelected = true
        selectVoiceAction(self.voice, self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isPlayingAudio = true
        }
    }
    
    func updateAfterVoiceDonePlaying() {
        self.voicePowers = [0.0, 0.0, 0.0]
        self.isPlayingAudio = false
    }
}
