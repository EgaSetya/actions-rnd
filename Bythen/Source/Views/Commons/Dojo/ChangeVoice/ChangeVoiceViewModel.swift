//
//  ChangeVoiceViewModel.swift
//  Bythen
//
//  Created by edisurata on 13/10/24.
//

import Foundation
import Combine

class ChangeVoiceViewModel: BaseViewModel {
    
    enum VoiceSampleState {
        case empty
        case loading
        case result
    }
    
    static func new(byteBuild: ByteBuild = ByteBuild()) -> ChangeVoiceViewModel {
        return ChangeVoiceViewModel(
            byteBuild: byteBuild,
            staticAssetService: StaticAssetsService(),
            speechService: SpeechService(),
            audioPlayer: AudioPlayer(),
            byteBuildService: ByteBuildService()
        )
    }
    
    @Published var selectedVoice: VoiceTag?
    @Published var selectedAccent: VoiceTag?
    @Published var selectedAge: VoiceTag?
    
    @Published var voices: [VoiceTagChipVM] = []
    @Published var accents: [VoiceTagChipVM] = []
    @Published var ages: [VoiceTagChipVM] = []
    @Published var voiceSamples: [VoiceSampleVM] = []
    @Published var voiceSampleState: VoiceSampleState = .empty
    
    private var staticAssetsService: StaticAssetsServiceProtocol
    private var speechService: SpeechServiceProtocol
    private var byteBuild: ByteBuild
    private var audioPlayer: AudioPlayerProtocol
    private var playAudioTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    private var playingSampleVoice: VoiceSampleVM?
    private var byteBuildService: ByteBuildServiceProtocol
    private var didUpdateByteBuild: (_ build: ByteBuild) -> Void = { _ in }
    
    init(
        byteBuild: ByteBuild,
        staticAssetService: StaticAssetsServiceProtocol,
        speechService: SpeechServiceProtocol,
        audioPlayer: AudioPlayerProtocol,
        byteBuildService: ByteBuildServiceProtocol
    ) {
        self.byteBuild = byteBuild
        self.staticAssetsService = staticAssetService
        self.speechService = speechService
        self.audioPlayer = audioPlayer
        self.byteBuildService = byteBuildService

        super.init()
        
    }
    
    func setupCallbacks(didUpdateByteBuild: @escaping (_ build: ByteBuild) -> Void = { _ in }) {
        self.didUpdateByteBuild = didUpdateByteBuild
    }
    
    func fetchData() {
        self.fetchVoiceTags()
        self.fetchVoiceSamples()
    }
    
    private func fetchVoiceTags() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            do {
                let resp: GetVoiceTagsResponse = try await self.staticAssetsService.getAssets(path: .voiceTags)
                self.voices = resp.base.map({ value in
                    return VoiceTagChipVM(
                        voiceTag: value,
                        selectVoiceAction: self.selectVoiceAction(voice:),
                        isSelected: self.byteBuild.voiceBase == value.value
                    )
                })
                self.accents = resp.accents.map({ value in
                    return VoiceTagChipVM(
                        voiceTag: value,
                        selectVoiceAction: self.selectAccentAction(accent:),
                        isSelected: self.byteBuild.voiceAccents == value.value
                    )
                })
                self.ages = resp.age.map({ value in
                    return VoiceTagChipVM(
                        voiceTag: value,
                        selectVoiceAction: self.selectAgeAction(age:),
                        isSelected: self.byteBuild.voiceAge == value.value
                    )
                })
            } catch {
                self.handleError(error)
            }
            
        }
    }
    
    func selectVoiceAction(voice: VoiceTag) {
        self.selectedVoice = voice
        self.byteBuild.voiceBase = voice.value
        self.fetchVoiceSamples()
        for _voice in self.voices {
            if _voice.value == voice.value { continue }
            _voice.isSelected = false
        }
    }
    
    func selectAccentAction(accent: VoiceTag) {
        self.selectedAccent = accent
        self.byteBuild.voiceAccents = accent.value
        self.fetchVoiceSamples()
        for _accent in self.accents {
            if _accent.value == accent.value { continue }
            _accent.isSelected = false
        }
    }
    
    func selectAgeAction(age: VoiceTag) {
        self.selectedAge = age
        self.byteBuild.voiceAge = age.value
        self.fetchVoiceSamples()
        for _age in self.ages {
            if _age.value == age.value { continue }
            _age.isSelected = false
        }
    }
    
    func fetchVoiceSamples() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.voiceSampleState = .loading
            let voices = try await self.speechService.getVoices(
                base: self.selectedVoice?.value ?? self.byteBuild.voiceBase,
                accent: self.selectedAccent?.value ?? self.byteBuild.voiceAccents,
                age: self.selectedAge?.value ?? self.byteBuild.voiceAge
            )
            
            self.voiceSamples = voices.map({ voice in
                return VoiceSampleVM(
                    voice: voice,
                    isSelected: voice.slug == self.byteBuild.voiceModel,
                    selectVoiceAction: self.selectVoiceSampleAction(voiceSample:selectedVM:))
            })
            
            if self.voiceSamples.isEmpty {
                self.voiceSampleState = .empty
            } else {
                self.voiceSampleState = .result
            }
        }
    }
    
    func selectVoiceSampleAction(voiceSample: Voice, selectedVM: VoiceSampleVM) {
        self.byteBuild.voiceModel = voiceSample.slug
        for sample in self.voiceSamples {
            sample.isSelected = sample.slug == voiceSample.slug
        }
        self.audioPlayer.stop()
        self.audioPlayer.playAudioFromRemoteURL(voiceSample.voiceSampleUrl)
        self.audioPlayer.playingAudioBufferSignal
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { (power, finished) in
                if !selectedVM.isPlayingAudio {
                    return
                }
                
                if finished {
                    selectedVM.updateAfterVoiceDonePlaying()
                    return
                }
                
                var powers = selectedVM.voicePowers
                powers.insert(power, at: 0)
                
                if powers.count > 3 {
                    powers.removeLast()
                }
                selectedVM.voicePowers = powers
            })
            .store(in: &cancellables)
    }
    
    func updateVoice() {
        self.audioPlayer.stop()
        Task { @MainActor [weak self] in
            guard let self else { return }
            defer {
                self.setLoading(isLoading: false)
            }
            
            self.setLoading(isLoading: true)
            self.didUpdateByteBuild(self.byteBuild)
            let params = UpdateByteBuildVoiceParam(
                base: self.byteBuild.voiceBase,
                accents: self.byteBuild.voiceAccents,
                age: self.byteBuild.voiceAge,
                model: self.byteBuild.voiceModel
            )
            try await self.byteBuildService.updateVoiceModel(byteID: self.byteBuild.byteId, byteSymbol: self.byteBuild.byteSymbol, params: params)
        }
    }
}
