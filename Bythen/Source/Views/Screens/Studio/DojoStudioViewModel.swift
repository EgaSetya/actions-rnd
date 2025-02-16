//
//  DojoStudioViewModel.swift
//  Bythen
//
//  Created by edisurata on 12/11/24.
//

import Combine
import Foundation
import Photos
import SwiftUI

class DojoStudioViewModel: BaseViewModel {
    static func new() -> DojoStudioViewModel {
        return DojoStudioViewModel(
            byteBuildService: ByteBuildService(),
            unityApi: UnityApi.shared,
            unityNotification: UnityNotification.shared,
            byteService: ByteService(),
            screenRecorder: ScreenRecorder()
        )
    }

    @Published var voiceModel: String = ""
    @Published var isHasBuild: Bool = false
    @Published var byte: Byte = .init()
    @Published var isUnityByteLoaded: Bool = false
    @Published var bytes: [Byte] = []
    @Published var emotion: String = "Neutral"
    @Published var ratio: AspectRatio = .potrait
    @Published var talkingSpeed: Double = 1.0
    @Published var script: String = ""
    @Published var shouldOpenScript: Bool = false
    @Published var shouldShowScriptButton: Bool = true
    @Published var bottomSheetType: DojoStudioFooterViewAction?
    @Published var isVideoSaved: Bool = false
    @Published var savedVideoID: String?
    @Published var isRecording: Bool = false
    @Published var isPlaying: Bool = false
    @Published var showRecordingAlert: Bool = false
    @Published var isChangeAvatar: Bool = false
    @Published var byteName: String = ""
    @Published var enableChangeBg: Bool = false
    @Published var showWatermark: Bool = false
    @Published var voicePitch: Int64 = 0
    @Published var isAssetReady: Bool = false
    @Published var enableDojoButton: Bool = false
    @Published var captions: String = ""
    @Published var showCaptions: Bool = false
    @Published var isEnableStudioRecordImprovement: Bool = false
    @Published var isShowLoading: Bool = false

    private var byteBuildService: ByteBuildServiceProtocol
    private var unityApi: UnityApiProtocol
    private var unityNotification: UnityNotificationProtocol
    private var cancellables: Set<AnyCancellable> = []
    private var byteBuild: ByteBuild?
    private var dojoVM: DojoViewModel?
    private let byteService: ByteServiceProtocol
    private var screenRecorder: ScreenRecorderProtocol
    private var captionTexts: [String] = []
    private var captionIdx: Int = 0

    init(
        byteBuildService: ByteBuildServiceProtocol,
        unityApi: UnityApiProtocol,
        unityNotification: UnityNotificationProtocol,
        byteService: ByteServiceProtocol,
        screenRecorder: ScreenRecorderProtocol
    ) {
        self.byteBuildService = byteBuildService
        self.unityApi = unityApi
        self.unityNotification = unityNotification
        self.byteService = byteService
        self.screenRecorder = screenRecorder
        super.init()
    }

    func fetchData() {
        self.isEnableStudioRecordImprovement = FeatureFlag.studioRecordImprovement.isFeatureEnabled()
        
        if isUnityByteLoaded {
            return
        }

        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                self.isChangeAvatar = true

                let build = try await self.byteBuildService.getBuildDefault()
                let bytes = try await byteService.getBytes()

                if let byte = bytes.bytes.first(where: { $0.byteData.byteID == build.byteData.byteID }) {
                    self.byte = byte
                }

                self.bytes = bytes.bytes
                self.updateByteBuild(build: build)
                if build.byteData.isTrial {
                    self.loadUnityByte(
                        byteTraits: build.byteData.traits,
                        backgroundType: .color,
                        background: build.byteData.backgroundColor,
                        isChangeByte: !self.isUnityByteLoaded
                    )
                } else {
                    self.loadUnityByte(
                        byteTraits: build.byteData.traits,
                        backgroundType: build.backgroundType,
                        background: build.background,
                        isChangeByte: !self.isUnityByteLoaded
                    )
                }
                self.enableDojoButton = true
            } catch {
                self.handleError(error)
            }
        }
    }

    func loadUnityByte(byteTraits: String, backgroundType: BackgroundType, background: String, isChangeByte: Bool = true) {
        if backgroundType == .image {
            unityApi.setBackgroundImage(imageUrl: background)
        } else {
            unityApi.setBackgroundColor(hexColorString: background)
        }

        if isChangeByte {
            isChangeAvatar = true
            isUnityByteLoaded = false
            unityApi.changeAvatarTraits(byteTraits)
        }
    }

    func listenUnitySignals() {
        if let signal = unityNotification.loadingScreenHiddenSignal {
            signal
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self else { return }
                    self.isUnityByteLoaded = true
                    self.isChangeAvatar = false
                    self.setLoading(isLoading: false)
                    self.unityApi.changeProductType(productType: .studio)
                }
                .store(in: &cancellables)
        }

        if let signal = unityNotification.avatarEndTalkingSignal {
            signal
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self else { return }
                    self.isPlaying = false
                    self.captions = ""
                    self.captionTexts = []
                    self.captionIdx = 0
                    if self.isRecording {
                        self.stopRecording()
                    }
                }
                .store(in: &cancellables)
        }
        
        if let signal = unityNotification.voicePlayedSignal {
            signal
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self else { return }
                    if self.showCaptions {
                        self.showNextCaption()
                    }
                }
                .store(in: &cancellables)
        }
        
        if let signal = unityNotification.audioReadySignal {
            signal
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self else { return }
                    isShowLoading = false
                    if isPlaying {
                        self.playUnityByte()
                    } else {
                        self.startRecording()
                    }
                }
                .store(in: &cancellables)
        }
    }

    func getDojoViewModel() -> DojoViewModel {
        if let build = byteBuild {
            let vm = DojoViewModel.new(byteBuild: build, isStudioMode: true)
            dojoVM = vm

            vm.byteUpdateSignal
                .receive(on: DispatchQueue.main)
                .sink { [weak self] newBuild in
                    guard let self else { return }
                    self.updateByteBuild(build: newBuild)
                }
                .store(in: &cancellables)

            return vm
        } else {
            return DojoViewModel.new(byteBuild: ByteBuild())
        }
    }

    func navToChat() -> (Int64, String) {
        if let build = byteBuild {
            return (build.byteData.byteID, build.byteData.byteSymbol)
        }

        return (0, "")
    }

    func didFinishEditScript(_ script: String) {
        self.script = script
        shouldOpenScript = false
    }

    func didSelectBottomSheet(_ type: DojoStudioFooterViewAction) {
        shouldShowScriptButton = false
        withAnimation(.easeInOut(duration: 0.15)) {
            bottomSheetType = type
        }
    }

    func didSelectByte(_ byte: Byte) {
        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                self.byte = byte
                self.isChangeAvatar = true
                self.isUnityByteLoaded = false
                didCancelBottomSheet()

                let byteBuild = try await byteBuildService.getBuild(
                    byteID: byte.byteData.byteID,
                    byteSymbol: byte.byteData.byteSymbol
                )

                self.updateByteBuild(build: byteBuild)
                if byteBuild.byteData.isTrial {
                    self.loadUnityByte(
                        byteTraits: byteBuild.byteData.traits,
                        backgroundType: .color,
                        background: byteBuild.byteData.backgroundColor,
                        isChangeByte: !self.isUnityByteLoaded
                    )
                } else {
                    self.loadUnityByte(
                        byteTraits: byteBuild.byteData.traits,
                        backgroundType: byteBuild.backgroundType,
                        background: byteBuild.background,
                        isChangeByte: !self.isUnityByteLoaded
                    )
                }
            } catch {
                Logger.logInfo("Error: \(error)")
                self.handleError(error)
            }
        }
    }

    func didSelectEmotion(_ emotion: String) {
        self.emotion = emotion
        didCancelBottomSheet()
    }

    func didSelectRatio(_ ratio: AspectRatio) {
        self.ratio = ratio
        didCancelBottomSheet()
    }

    func didSelectTalkingSpeed(_ speed: Double) {
        talkingSpeed = speed
        didCancelBottomSheet()
    }

    func didCancelBottomSheet() {
        shouldShowScriptButton = true
        withAnimation(.easeInOut(duration: 0.15)) {
            bottomSheetType = nil
        }
    }
    
    func prepareUnityPlayer(recording: Bool) {
        isShowLoading = true
        isPlaying = !recording
        unityApi.setTalkingSpeed(value: Float(talkingSpeed))
        let sentences = seperateScript()
        unityApi.requestAudio(voiceID: voiceModel, voicePitch: voicePitch, voiceTexts: sentences)
    }

    func startRecording() {
        if script.isEmpty {
            showRecordingAlert = true
            return
        }

        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self else { return }
            guard status == .authorized else {
                return
            }

            DispatchQueue.main.async {
                self.isRecording = true
                self.screenRecorder.startRecording {
                    self.playUnityByte()
                } failure: { _ in
                    self.isRecording = false
                }
            }
        }
    }

    func stopRecording() {
        if isRecording {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                guard let self else { return }
                self.screenRecorder.stopRecording { url in
                    DispatchQueue.main.async {
                        self.unityApi.stopGenerate()
                        self.isPlaying = false
                        self.isRecording = false

                        if let url = url {
                            self.isVideoSaved = false
                            self.saveToPhotoLibrary(videoURL: url)
                        }
                    }
                }
            }
        }
    }

    func saveToPhotoLibrary(videoURL: URL) {
        PHPhotoLibrary.shared().performChanges(
            {
                let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                let placeholder = creationRequest?.placeholderForCreatedAsset
                let assetID = placeholder?.localIdentifier
                DispatchQueue.main.async {
                    self.savedVideoID = assetID
                }
            }
        ) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.isVideoSaved = true
                }

                Logger.logInfo("done save to library")
            } else if let error {
                Logger.logError(err: error)
            }

            try? FileManager.default.removeItem(at: videoURL)
        }
    }

    func playUnityByte() {
        isPlaying = true
        if isEnableStudioRecordImprovement {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.unityApi.startRecord()
            }
        } else {
            unityApi.setTalkingSpeed(value: Float(talkingSpeed))
            unityApi.startAvatarAnimation()
            let sentences = seperateScript()
            captionTexts = sentences
            for text in sentences {
                unityApi.triggerAvatarVoice(text, emotion: emotion, voiceID: voiceModel, voicePitch: voicePitch)
            }
            unityApi.endChatResponse()
        }
    }

    func stopPlaying() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isPlaying = false
            self.unityApi.stopGenerate()
        }
    }

    func getChangeBgViewModel() -> ChangeBackgroundVM {
        if let byteBuild = byteBuild {
            return ChangeBackgroundVM.new(
                byteID: byteBuild.byteId,
                byteSymbol: byteBuild.byteSymbol,
                originSymbol: byteBuild.byteData.originalTokenSymbol,
                background: byteBuild.background,
                backgroundType: byteBuild.backgroundType
            )
        }

        return ChangeBackgroundVM.new(byteID: 0, byteSymbol: "", originSymbol: "", background: "", backgroundType: .color)
    }
    
    func seperateScript() -> [String] {
        // Regular expression pattern to match sentence-ending punctuation
        let pattern = "[.!?\\n]"
        let text = script.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            
            // Split text into components using the regex matches as separators
            let range = NSRange(location: 0, length: text.utf16.count)
            let matches = regex.matches(in: text, options: [], range: range)
            
            var lastEnd = text.startIndex
            var sentences = [String]()
            
            // Collect the substrings for sentences
            for match in matches {
                let end = text.index(text.startIndex, offsetBy: match.range.location)
                let sentence = text[lastEnd..<end].trimmingCharacters(in: .whitespaces)
                if !sentence.isEmpty {
                    sentences.append(sentence)
                }
                lastEnd = text.index(after: end) // Move past the punctuation
            }
            
            // Add the last portion after the final punctuation
            let lastSentence = text[lastEnd...].trimmingCharacters(in: .whitespaces)
            if !lastSentence.isEmpty {
                sentences.append(lastSentence)
            }
            return sentences
        } catch {
            Logger.logError(err: error)
            return []
        }
    }
    
    func showNextCaption() {
        if captionTexts.count > captionIdx {
            let text = captionTexts[captionIdx]
            // Split string by any whitespace character
            let words = text.split { $0.isWhitespace }
            captions = ""
            for word in words {
                captions = "\(captions) \(word)"
            }
            captionIdx = captionIdx + 1
        }
    }
    
    // MIght be used later to separate captions into smaller substring
    func generateCaptions(text: String) async {
        // Split string by any whitespace character
        let words = text.split { $0.isWhitespace }
        // Convert Substring array to String array
        let wordList = words.map { String($0) }
        
        var totalDelay: Float = 0.0
        var nextCaption = ""
        let separatorsSet: Set = [".", "!", "?"]
        for word in wordList {
            nextCaption = "\(nextCaption) \(word)"
            var delay = min(Float(nextCaption.count) * 0.1, 0.4)
            if [",", ":", "-"].contains(word) {
                delay = delay + 0.1
            }
            totalDelay = min(totalDelay + delay, 1.7)
            
            if separatorsSet.contains(where: { word.hasSuffix($0) }) ||  nextCaption.count > 32 {
                self.captions = nextCaption
                try? await Task.sleep(nanoseconds: UInt64(totalDelay * 1_000_000_000))
                nextCaption = ""
                totalDelay = 0.0
            }
        }
        
        if nextCaption.count > 0 {
            self.captions = nextCaption
            try? await Task.sleep(nanoseconds: UInt64(totalDelay * 1_000_000_000))
        }
        
        captions = ""
    }

    private func updateByteBuild(build: ByteBuild) {
        byteBuild = build
        voiceModel = build.voiceModel
        isHasBuild = build.buildID != 0
        byteName = build.byteName
        enableChangeBg = true
        showWatermark = build.byteData.isTrial
        voicePitch = build.voicePitch
        isAssetReady = build.byteData.isAssetReady
    }
}
