//
//  AvatarViewModel.swift
//  Bythen
//
//  Created by edisurata on 14/09/24.
//

import Combine
import Foundation
import UIKit

import FirebasePerformance

class AvatarViewModel: BaseViewModel {
    enum AvatarState {
        case unload
        case loading
        case ready
        case talking
    }
    
    enum OverlayViewState {
        case onboardingDojo
        case empty
    }
    
    static func new(byteBuild: ByteBuild, tapChatModeAction: @escaping () -> Void = {}, onboarding: Bool = false) -> AvatarViewModel {
        return AvatarViewModel(
            byteBuild: byteBuild,
            chatService: ChatService(),
            audioListener: AudioListener(),
            audioFileRecorder: AudioFileRecorder(),
            speechService: SpeechService(),
            unityApi: UnityApi.shared,
            roomService: RoomService(),
            unityNotification: UnityNotification.shared,
            mediaBytesService: MediaBytesService(),
            tapChatModeAction: tapChatModeAction,
            onboarding: onboarding
        )
    }
    
    @Published var isListening: Bool = false
    @Published var voicePower: [Double] = [0.0, 0.0, 0.0]
    @Published var voiceState: VoiceModeState = .hidden
    @Published var uploadedFileName: String = ""
    @Published var byteName: String = ""
    @Published var isShowImagePicker: Bool = false
    @Published var uploadProgress: Double = 0.0
    @Published var isMute: Bool = false
    @Published var avatarState: AvatarState = .unload
    @Published var showMemoryLimit: Bool = false
    @Published var enableAudio: Bool = false
    @Published var isTrial: Bool = false
    @Published var voicePitch: Int64 = 0
    @Published var roomID: Int64 = 0
    @Published var overlayViewState: OverlayViewState = .empty
    
    var dojoViewModel: DojoViewModel
    
    var tapChatModeAction: () -> Void
    var byteBuildUpdatedSignal: AnyPublisher<ByteBuild, Never> {
        get {
            return byteBuildUpdatedSubject.eraseToAnyPublisher()
        }
    }
    var byteDidLoadedSignal: AnyPublisher<Void, Never> {
        get {
            return byteDidLoadedSubject.eraseToAnyPublisher()
        }
    }
    
    var didNewRoomCreated: (Int64) -> Void = { _ in }
    
    var reloadPageHandler: (() -> Void)?

    // MARK: - Services
    private var speechService: SpeechServiceProtocol
    private var chatService: ChatServiceProtocol
    private var roomService: RoomServiceProtocol
    private var mediaBytesService: MediaBytesServiceProtocol
    private var audioListener: AudioListenerProtocol
    private var audioFileRecorder: AudioFileRecorderProtocol
    private var unityApi: UnityApiProtocol
    private var unityNotification: UnityNotificationProtocol

    private var cancellables = Set<AnyCancellable>()
    private var generateResponseTask: Task<Void, Error>?
    private var byteDidLoadedSubject = PassthroughSubject<Void, Never>()
    private var byteBuildUpdatedSubject = PassthroughSubject<ByteBuild, Never>()
    private var byteBuild: ByteBuild
    private var isAvatarLoaded: Bool = false
    
    private var voiceChatPerformanceTrace: Trace?
    private var voiceChatApiCallPerformanceTrace: Trace?

    init(
        byteBuild: ByteBuild,
        chatService: ChatServiceProtocol,
        audioListener: AudioListenerProtocol,
        audioFileRecorder: AudioFileRecorderProtocol,
        speechService: SpeechServiceProtocol,
        unityApi: UnityApiProtocol,
        roomService: RoomServiceProtocol,
        unityNotification: UnityNotificationProtocol,
        mediaBytesService: MediaBytesServiceProtocol,
        tapChatModeAction: @escaping () -> Void,
        onboarding: Bool = false
    ) {
        self.byteBuild = byteBuild
        self.chatService = chatService
        self.audioListener = audioListener
        self.audioFileRecorder = audioFileRecorder
        self.speechService = speechService
        self.unityApi = unityApi
        self.roomService = roomService
        self.unityNotification = unityNotification
        self.tapChatModeAction = tapChatModeAction
        self.mediaBytesService = mediaBytesService
        self.dojoViewModel = DojoViewModel.new(byteBuild: byteBuild)
        if onboarding {
            self.overlayViewState = .onboardingDojo
        }
        super.init()
        updateByte(build: byteBuild)
        setupAvatar()
        self.dojoViewModel.byteUpdateSignal.sink { [weak self] build in
            guard let self else { return }
            
            self.byteBuild = build
            updateByte(build: build)
            byteBuildUpdatedSubject.send(build)
        }.store(in: &cancellables)
        self.dojoViewModel.didResetBuild = { [weak self] in
            guard let self else { return }
            if let handler = self.reloadPageHandler {
                avatarState = .loading
                isAvatarLoaded = false
                handler()
            }
        }
    }

    func updateByte(build: ByteBuild) {
        DispatchQueue.main.async {
            self.roomID = build.roomID
            self.byteName = build.byteName
            self.isTrial = build.byteData.isTrial
            self.voicePitch = build.voicePitch
        }
        dojoViewModel = DojoViewModel.new(byteBuild: byteBuild)
        dojoViewModel.byteUpdateSignal.sink { [weak self] build in
            guard let self else { return }
            
            self.byteBuild = build
            self.updateByte(build: build)
            self.byteBuildUpdatedSubject.send(build)
        }.store(in: &cancellables)
        dojoViewModel.didResetBuild = { [weak self] in
            guard let self else { return }
            if let handler = self.reloadPageHandler {
                self.avatarState = .loading
                self.isAvatarLoaded = false
                handler()
            }
        }
    }
    
    func chatModeAction() {
        tapChatModeAction()
    }
    
    // MARK: - Avatar
    
    func setupAvatar() {
        $avatarState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .ready:
                    unityApi.stopGenerate()
                    setVoiceState(.startSpeaking)
                    startAudioRecording()
                case .talking:
                    stopAudioRecording()
                    setVoiceState(.generating)
                    unityApi.startAvatarAnimation()
                case .unload:
                    if let task = generateResponseTask {
                        task.cancel()
                    }
                    unityApi.stopGenerate()
                    setVoiceState(.hidden)
                    stopAudioRecording()
                    audioListener.stopListener()
                case .loading:
                    stopAudioRecording()
                    setVoiceState(.hidden)
                    unityApi.stopGenerate()
                }
                
            }
            .store(in: &cancellables)
        
        observerUnity()
    }
    
    func loadAvatar() {
        if avatarState == .loading { return }
        if isAvatarLoaded {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.avatarState = .ready
            }
            return
        }
        
        avatarState = .loading
        if byteBuild.backgroundType == .image {
            unityApi.setBackgroundImage(imageUrl: byteBuild.background)
        } else {
            unityApi.setBackgroundColor(hexColorString: byteBuild.background)
        }
        
        if let lastTraits = mainState?.appSession.getLastTraits(), lastTraits == byteBuild.byteData.traits {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isAvatarLoaded = true
                self.avatarState = .ready
                self.byteDidLoadedSubject.send()
            }
            return
        }
        
        mainState?.appSession.setLastTraits(byteBuild.byteData.traits)
        unityApi.startAvatar(byteBuild.byteData.traits)
        if !byteBuild.byteData.isAssetReady {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isAvatarLoaded = true
                self.avatarState = .ready
                self.byteDidLoadedSubject.send()
            }
        }
    }
    
    func stopAvatar() {
        avatarState = .unload
    }
    
    func observerUnity() {
        if let signal = unityNotification.avatarEndTalkingSignal {
            signal
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self else { return }
                    if avatarState == .unload { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.avatarState = .ready
                    }
                }.store(in: &cancellables)
        }
        
        if let signal = self.unityNotification.loadingScreenHiddenSignal {
            signal
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self else { return }
                    if avatarState == .unload { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.byteDidLoadedSubject.send()
                        self.isAvatarLoaded = true
                        self.avatarState = .ready
                        self.unityApi.changeProductType(productType: .chatroom)
                    }
                }
                .store(in: &cancellables)
        }
        
        if let signal = unityNotification.avatarStartTalkingSignal {
            signal.receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.voiceChatPerformanceTrace?.stop()
                }.store(in: &cancellables)
        }
    }
    
    // MARK: - Voice
    
    func muteMicrophone() {
        switch voiceState {
        case .listening, .startSpeaking:
            break
        default:
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self else { return }
            isMute.toggle()
            Task {
                if self.isMute {
                    self.stopAudioRecording()
                } else {
                    self.startAudioRecording()
                }
            }
        }
    }
    
    func interruptResponse() {
        if let task = generateResponseTask {
            task.cancel()
            self.avatarState = .ready
        }
    }
    
    private func startAudioRecording() {
        if !self.enableAudio {
            return
        }
        
        if self.avatarState != .ready {
            return
        }
        if self.isMute {
            return
        }
        
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            do {
                generateResponseTask = nil
                try await audioListener.prepareForRecord()
                audioFileRecorder.prepareAudioFile(settings: audioListener.getRecordingFormat())
                for await audioBuff in audioListener.startRecording(isSilenceDetectionEnabled: true) {
                    if let buffer = audioBuff.buffer {
                        audioFileRecorder.recordAudio(buffer: buffer)
                    }
                    updateVoice(audioBuff: audioBuff)
                }
                
                if avatarState != .ready {
                    return
                }
                
                avatarState = .talking
                generateResponseTask = Task { @MainActor [weak self] in
                    guard let self else { return }
                    await generateChatResponse()
                }

            } catch {}
        }
    }

    private func stopAudioRecording() {
        resetVoicePower()
        audioListener.stopRecording()
        audioFileRecorder.finishAudioRecording()
    }
    
    private func updateVoice(audioBuff: AudioBuffer) {
        voicePower.insert(Double(audioBuff.amplitude), at: 0)
        if voicePower.count > 3 {
            voicePower.removeLast()
        }

        if audioBuff.amplitude > 0 {
            setVoiceState(.listening)
        }
    }

    private func resetVoicePower() {
        voicePower = [0.0, 0.0, 0.0]
    }
    
    private func transcriptAudioToText(fileUrl: URL) async throws -> String {
        let fileAttributes = try FileManager.default.attributesOfItem(atPath: fileUrl.path)
        if let size = fileAttributes[.size] as? Int64 {
            Logger.logInfo("audio size: \(size) bytes")
        }
        let transcriptText = try await speechService.transcript(fileUrl: fileUrl)
        Logger.logInfo("transcript text: \(transcriptText)")
        return transcriptText
    }
    
    private func setVoiceState(_ state: VoiceModeState) {
        voiceState = state
        if state == .interrupt || state == .uploadSuccess {
            triggerVibration()
        }
    }
    
    // MARK: - Upload
    
    func attachmentAction() {
        if !isMute {
            self.muteMicrophone()
        }
        self.isShowImagePicker = true
    }
    
    func didSelectImage(image: Attachment) {
        avatarState = .talking
        generateResponseTask = Task { @MainActor [weak self] in
            guard let self else { return }
            setVoiceState(.uploading)
            do {
                let resp = try await mediaBytesService.uploadChatFile(
                    fileUrl: image.fileURL,
                    buildID: byteBuild.buildID) { progress in
                        self.uploadProgress = progress
                    }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.uploadedFileName = image.fileName
                    self.setVoiceState(.uploadSuccess)
                }
                
                try await getChatbotResponse(message: "", fileUrl: resp.fileURL)
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.handleError(error)
                    if self.avatarState == .unload {
                        return
                    }
                    self.avatarState = .ready
                }
            }
        }
    }

    
    // MARK: - Chat
    
    private func generateChatResponse() async {
        do {
            if var audioUrl = self.audioFileRecorder.audioRecordUrl {
                do {
                    audioUrl = try await self.audioFileRecorder.compressAudio()
                } catch {}
                
                let transcriptMessage: String = try await self.transcriptAudioToText(fileUrl: audioUrl)
                if transcriptMessage != "" {
                    try await self.getChatbotResponse(message: transcriptMessage)
                } else {
                    Logger.logInfo("Empty Transcript")
                    if self.avatarState == .talking {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.avatarState = .ready
                        }
                    }
                }
            }
        } catch {
            self.handleError(error)
            if self.avatarState == .talking {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.avatarState = .ready
                }
            }
        }
    }
    
    private func getChatbotResponse(message: String, fileUrl: String? = nil) async throws {
        var isNeedChatSummarize = false
        if roomID == 0 {
            Logger.logInfo("Create room")
            let roomID: Int64 = try await roomService.createRooms(buildID: byteBuild.buildID, title: "New Room")
            self.roomID = roomID
            isNeedChatSummarize = true
            didNewRoomCreated(roomID)
        }

        Logger.logInfo("Get Chatbot Response")
        
        startPerformanceMonitoring(message)
        
        let streamMessages = chatService.chatBytes(
            buildID: byteBuild.buildID,
            roomID: roomID,
            message: message,
            fileURL: fileUrl
        )
        
        setVoiceState(.interrupt)
        for await listChatResp in streamMessages {
            voiceChatApiCallPerformanceTrace?.stop()
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                for chatResp in listChatResp {
                    if chatResp.processing == "memory" {
                        if self.voiceState != .memoryUpdated {
                            self.voiceState = .memoryUpdated
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                if self.voiceState == .memoryUpdated {
                                    self.voiceState = .interrupt
                                }
                            }
                        }
                    }
                    if chatResp.showMemoryLimit {
                        showMemoryLimit = true
                    }
                    if chatResp.voice != "" {
                        unityApi.setTalkingSpeed(value: 1.0)
                        unityApi.triggerAvatarVoice(chatResp.voice, emotion: chatResp.emotion, voiceID: self.byteBuild.voiceModel, voicePitch: voicePitch)
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.unityApi.endChatResponse()
        }
        
        if isNeedChatSummarize {
            Logger.logInfo("Summarize room")
            let _: ChatSummaryResponse = try await chatService.chatBytesSummary(buildID: byteBuild.buildID, roomID: roomID)
        }
    }
    
    // MARK: - Callback
    func changeRoom(roomID: Int64) {
        self.roomID = roomID
    }

    func changeByte(byteBuild: ByteBuild) {
        DispatchQueue.main.async {
            if byteBuild.buildID != self.byteBuild.buildID {
                self.isAvatarLoaded = false
            }
            self.byteBuild = byteBuild
            self.updateByte(build: byteBuild)
            self.loadAvatar()
        }
    }
    
    // MARK: -

    func getChangeBgViewModel() -> ChangeBackgroundVM {
        return ChangeBackgroundVM.new(byteID: byteBuild.byteId, byteSymbol: byteBuild.byteSymbol, originSymbol: byteBuild.byteData.originalTokenSymbol, background: byteBuild.background, backgroundType: byteBuild.backgroundType)
    }
    
    func getDojoViewModel(selectedTab: DojoTab) -> DojoViewModel {
        self.dojoViewModel.selectedTab = selectedTab
        return self.dojoViewModel
    }

    func triggerVibration() {
        // Trigger a short vibration
         let generator = UIImpactFeedbackGenerator(style: .medium)
         generator.prepare() // Prepares the generator for immediate feedback
         generator.impactOccurred() // Triggers the vibration
    }
    
    // MARK: Performance Monitoring
    func startPerformanceMonitoring(_ message: String) {
        voiceChatPerformanceTrace = PerformanceMonitoring.voiceChat.startTracing()
        voiceChatApiCallPerformanceTrace = PerformanceMonitoring.voiceChatApiCall.startTracing()
        voiceChatApiCallPerformanceTrace?.setValue(message, forAttribute: "message")
    }
}
