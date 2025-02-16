//
//  ChatTextFIeldViewModel.swift
//  Bythen
//
//  Created by Darindra R on 26/09/24.
//

import Combine
import SwiftUI

class ChatTextFieldViewModel: BaseViewModel {
    @Published var isFocused: Bool = false
    @Published var isRecording: Bool = false
    @Published var isGeneratingResponse: Bool = false

    @Published var elapsedTime: Int = 0
    @Published var elapsedTimeString: String = "00:00"
    @Published var timerCancellable: Cancellable?

    @Published var voicePower: [Double] = [0.0, 0.0, 0.0]

    @Published var text: String = ""
    @Published var attachment: Attachment?

    let didTapSendMessage = PassthroughSubject<ChatHistory, Never>()

    private let audioListener: AudioListenerProtocol
    private let speechService: SpeechServiceProtocol
    private let audioFileRecorder: AudioFileRecorderProtocol

    init(
        audioListener: AudioListenerProtocol = AudioListener(),
        speechService: SpeechServiceProtocol = SpeechService(),
        audioFileRecorder: AudioFileRecorderProtocol = AudioFileRecorder()
    ) {
        self.audioListener = audioListener
        self.speechService = speechService
        self.audioFileRecorder = audioFileRecorder
    }

    let timer = Timer.publish(every: 1, on: .main, in: .common)
    let animateDots = [
        [
            "duration": 0.6,
            "delay": 0.2,
        ],
        [
            "duration": 0.3,
            "delay": 0.4,
        ],
        [
            "duration": 0.4,
            "delay": 0.3,
        ],
    ]

    func startRecording() {
        isFocused = false
        isRecording = true
        timerCancellable = timer.autoconnect().sink { [weak self] _ in
            guard let self else { return }
            self.elapsedTime += 1
            self.elapsedTimeString = formattedTime()
        }

        Task { @MainActor [weak self] in
            do {
                guard let self else { return }
                try await self.audioListener.prepareForRecord()
                self.audioFileRecorder.prepareAudioFile(settings: self.audioListener.getRecordingFormat())

                for await audioBuff in self.audioListener.startRecording(isSilenceDetectionEnabled: false) {
                    self.voicePower.insert(Double(audioBuff.amplitude), at: 0)
                    if self.voicePower.count > 3 {
                        self.voicePower.removeLast()
                    }

                    if let buffer = audioBuff.buffer {
                        self.audioFileRecorder.recordAudio(buffer: buffer)
                    }
                }

            } catch {
                Logger.logDebug("Error recording audio: \(error.localizedDescription)")
            }
        }
    }

    func stopRecording() {
        isLoading = true
        isRecording = false

        timerCancellable?.cancel()
        timerCancellable = nil

        elapsedTime = 0
        elapsedTimeString = "00:00"

        audioListener.stopRecording()
        audioFileRecorder.finishAudioRecording()

        Task { @MainActor [weak self] in
            guard let self else { return }
            defer {
                self.isLoading = false
            }
            let _ = try await self.audioFileRecorder.compressAudio()
            if var audioUrl = self.audioFileRecorder.audioRecordUrl {
                do {
                    audioUrl = try await self.audioFileRecorder.compressAudio()
                } catch {}
                let transcript = await self.transcriptAudioToText(fileUrl: audioUrl)
                self.text = transcript
            } else {
                self.mainState?.showError(errMsg: "Failed to record audio. Please try again.")
            }
        }
    }

    func sendMessage() {
        defer {
            text = ""
            attachment = nil
        }

        let chat = ChatHistory(
            id: 0,
            content: text,
            role: .user,
            attachment: attachment
        )

        didTapSendMessage.send(chat)
    }

    private func formattedTime() -> String {
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func transcriptAudioToText(fileUrl: URL) async -> String {
        do {
            return try await speechService.transcript(fileUrl: fileUrl)
        } catch {
            if let mainState = mainState {
                DispatchQueue.main.async {
                    mainState.showError(errMsg: "Failed to transcript audio. Please try again.")
                }
            }

            return ""
        }
    }
}
