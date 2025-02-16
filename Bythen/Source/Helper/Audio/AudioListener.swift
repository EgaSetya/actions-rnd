//
//  AudioListener.swift
//  Bythen
//
//  Created by edisurata on 17/09/24.
//

import AVFoundation
import Combine

protocol AudioListenerProtocol {
    func prepareForRecord() async throws
    func stopRecording()
    func startRecording(isSilenceDetectionEnabled: Bool) -> AsyncStream<AudioBuffer>
    func getRecordingFormat() -> [String: Any]
    func prepareAudioSessionForPlayback() throws
    func prepareAudioSessionForRecord() throws
    func stopListener() 
}

class AudioListener: AudioListenerProtocol {
    private var audioEngine: AVAudioEngine?
    private var lastNonSilenceDate: Double = 0
    private var silenceThreshold: Float = -30.0
    private var maxThreshold: Float = -20
    private var minThreshold: Float = -40
    private var thresholdPowers: [Float] = []
    private var maxThresholdPowersCount = 30
    private var isListening: Bool = false
    
    init() {
    }
    
    func prepareForRecord() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    // Permission granted
                    if self.audioEngine == nil {
                        self.audioEngine = AVAudioEngine()
                    }
                    
                    do {
                        try prepareAudioSessionForRecord()
                    } catch {
                        Logger.logError(err: error)
                    }
                    continuation.resume()
                } else {
                    // Handle permission not granted
                    continuation.resume(throwing: AppError(code: 20, message: "AudioRecordPermissionDenied"))
                }
            }
        }
    }
    
    func stopRecording() {
        guard let audioEngine else { return }
        if isListening {
            isListening = false
            lastNonSilenceDate = 0
            audioEngine.inputNode.removeTap(onBus: 0)
            audioEngine.stop()
            Logger.logInfo("Audio Stop")
//            stopAudioSession()
            do {
                try prepareAudioSessionForPlayback()
            } catch {
                Logger.logError(err: error)
            }
        }
    }
    
    func startRecording(isSilenceDetectionEnabled: Bool = false) -> AsyncStream<AudioBuffer> {
        return AsyncStream { [weak self] continuation in
            guard let self = self else {
                return
            }
            guard let audioEngine else {
                return
            }
            if isListening {
                return
            }
            
            do {
                try self.prepareAudioSessionForRecord()
                self.isListening = true
                
                let inputNode = audioEngine.inputNode
                let format = inputNode.inputFormat(forBus: 0)
                
                inputNode.installTap(onBus: 0, bufferSize: 2048, format: format) { [weak self] (buffer, time) in
                    guard let self = self else { return }
                    self.processBuffer(
                        withContinuation: continuation,
                        buffer: buffer,
                        time: time,
                        format: format,
                        isSilenceDetectionEnabled: isSilenceDetectionEnabled
                    )
                }
                try audioEngine.start()
            } catch {
                Logger.logError(err: error)
            }
        }
    }
    
    func getRecordingFormat() -> [String: Any] {
        guard let audioEngine else { return [:] }
        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)
        
        return format.settings
    }
    
    func prepareAudioSessionForRecord() throws {
        guard audioEngine != nil else { return }
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.category != .playAndRecord {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth, .allowAirPlay])
        }
        try audioSession.setActive(true)
        Logger.logInfo("AudioSession set to record")
            
    }
    
    func prepareAudioSessionForPlayback() throws {
        guard audioEngine != nil else { return }
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.category != .playback {
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowBluetooth, .allowBluetoothA2DP, .allowAirPlay])
        }
        try audioSession.setActive(true)
        Logger.logInfo("AudioSession set to playback")
    }
    
    func stopAudioSession() {
        guard audioEngine != nil else { return }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch let err {
            Logger.logError(err: err)
        }
    }
    
    func stopListener() {
        self.audioEngine = nil
        self.stopAudioSession()
    }
    
    private func processBuffer(withContinuation continuation: AsyncStream<AudioBuffer>.Continuation , buffer: AVAudioPCMBuffer, time: AVAudioTime, format: AVAudioFormat, isSilenceDetectionEnabled: Bool = false) {
        guard let channelData = buffer.floatChannelData?[0] else {
            return
        }
        
        let channelDataArray = Array(UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength)))
        
        // Calculate the root mean square (RMS) of the buffer
        let rms = sqrt(channelDataArray.map { $0 * $0 }.reduce(0, +) / Float(channelDataArray.count))
        
        // Convert RMS to decibels
        let averagePower = 20 * log10(rms)
        let amplitude = min(max(rms * abs(silenceThreshold / 3), 0.0), 1.0)
        if isSilenceDetectionEnabled {
            let seconds = self.getRecordingTimeInSeconds(from: time, format: format)
            normalizeSilenceThreshold(power: averagePower)
            if averagePower < silenceThreshold {
                continuation.yield(AudioBuffer(buffer: buffer, power: averagePower, amplitude: 0, threshold: silenceThreshold))
                if (lastNonSilenceDate > 0) && (seconds - lastNonSilenceDate) > 2 {
                    Logger.logInfo("silence detected")
                    stopRecording()
                    continuation.finish()
                }
            } else {
                lastNonSilenceDate = seconds
                continuation.yield(AudioBuffer(buffer: buffer, power: averagePower, amplitude: amplitude, threshold: silenceThreshold))
            }
        } else {
            continuation.yield(AudioBuffer(buffer: buffer, power: averagePower, amplitude: amplitude, threshold: 0))
        }
        
    }
    
    private func getRecordingTimeInSeconds(from time: AVAudioTime, format: AVAudioFormat) -> Double {
        let sampleRate = format.sampleRate
        
        if time.isSampleTimeValid {
            let sampleTime = time.sampleTime
            return Double(sampleTime) / sampleRate
        } else {
            return 0
        }
    }
    
    private func normalizeSilenceThreshold(power: Float) {
        self.thresholdPowers.insert(power, at: 0)
        if self.thresholdPowers.count > maxThresholdPowersCount {
            let sum = thresholdPowers.reduce(0, +) // Sum of all elements
            let average = Float(sum) / Float(thresholdPowers.count)
            if average > -20 {
                self.silenceThreshold = average
            } else if average > -50 && average <= -20 {
                self.silenceThreshold = average + 5
            } else {
                self.silenceThreshold = average + 10
            }
            self.thresholdPowers = []
        }
    }
}
