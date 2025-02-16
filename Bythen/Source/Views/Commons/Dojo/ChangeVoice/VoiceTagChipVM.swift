//
//  VoiceTagChipVM.swift
//  Bythen
//
//  Created by edisurata on 14/10/24.
//

import Foundation

class VoiceTagChipVM: BaseViewModel {
    @Published var isSelected: Bool = false
    @Published var label: String
    var value: String
    
    var selectVoiceAction: (_ voiceTag: VoiceTag) -> Void
    
    private var voiceTag: VoiceTag
    
    init(voiceTag: VoiceTag, selectVoiceAction: @escaping (_ voiceTag: VoiceTag) -> Void, isSelected: Bool = false) {
        self.voiceTag = voiceTag
        self.label = voiceTag.label.uppercased()
        self.value = voiceTag.value
        self.isSelected = isSelected
        self.selectVoiceAction = selectVoiceAction
    }
    
    func tapAction() {
        self.isSelected = true
        selectVoiceAction(self.voiceTag)
    }
}
