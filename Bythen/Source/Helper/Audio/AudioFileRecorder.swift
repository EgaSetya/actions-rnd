//
//  AudioFileRecorder.swift
//  Bythen
//
//  Created by edisurata on 17/09/24.
//

import AVFoundation

protocol AudioFileRecorderProtocol {
    var audioRecordUrl: URL? { get }
    var compressedAudioRecordUrl: URL? { get }
    func prepareAudioFile(settings: [String: Any])
    func recordAudio(buffer: AVAudioPCMBuffer)
    func finishAudioRecording()
    func playAudio()
    func compressAudio() async throws -> URL
}

class AudioFileRecorder: AudioFileRecorderProtocol {
    
    var audioRecordUrl: URL?
    private var audioFile: AVAudioFile?
    private var playerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    private var engine: AVAudioEngine = AVAudioEngine()
    private var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    var compressedAudioRecordUrl: URL?
    
    func prepareAudioFile(settings: [String: Any]) {
        if audioRecordUrl == nil {
            audioRecordUrl = FileManager.default.temporaryDirectory.appendingPathComponent("tempAudiOuput" + ".wav")
        }
        
        do {
//            if FileManager.default.fileExists(atPath: audioRecordUrl!.path) {
//                Logger.logInfo("audio file exists, removing")
//                try FileManager.default.removeItem(at: audioRecordUrl!)
//            }
            audioFile = try AVAudioFile(forWriting: audioRecordUrl!, settings: settings)
        } catch {
            print("Error opening audio file: \(error)")
            return
        }
    }
    
    func recordAudio(buffer: AVAudioPCMBuffer) {
        guard let audioFile = audioFile else { return }
        
        do {
            // Write the buffer to the file
            if buffer.frameLength == 0 { return }
            try audioFile.write(from: buffer)
        } catch {
            print("Error writing buffer to file: \(error)")
        }
    }
    
    private func prepareForPlayback() {
        engine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.category == .playback {
            return
        }
        
        do {
            try audioSession.setCategory(.playback, mode: .voicePrompt, options: [])
            try audioSession.setActive(true)
            Logger.logInfo("AudioSession set to playback")
        } catch let err {
            Logger.logError(err: err)
        }
    }
    
    func finishAudioRecording() {
        self.audioFile = nil
    }
    
    func compressAudio() async throws -> URL {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else { return }
            var hasResumed = false
            if self.compressedAudioRecordUrl == nil {
                self.compressedAudioRecordUrl = FileManager.default.temporaryDirectory.appendingPathComponent("finalAudiOuput" + ".m4a")
            }
            
            if let inputUrl = self.audioRecordUrl, let outputUrl = self.compressedAudioRecordUrl {
                if FileManager.default.fileExists(atPath: outputUrl.path) {
                    Logger.logInfo("audio file exists, removing")
                    do {
                        try FileManager.default.removeItem(at: outputUrl)
                    } catch let err {
                        continuation.resume(throwing: err)
                    }
                }
                
                self.convertWAVToM4A(wavURL: inputUrl, outputURL: outputUrl) { result in
                    guard !hasResumed else { return }
                    hasResumed = true
                    
                    switch result {
                    case .success(let m4aURL):
                        print("Successfully compressed to M4A: \(m4aURL)")
                        // Now you can use this `m4aURL` to send it over the network
                        continuation.resume(returning: m4aURL)
                    case .failure(let error):
                        print("Error compressing audio: \(error)")
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    func convertWAVToM4A(wavURL: URL, outputURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let asset = AVAsset(url: wavURL)
        
        // Create export session
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            completion(.failure(NSError(domain: "Conversion Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create AVAssetExportSession"])))
            return
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = .m4a
        
        // Start export
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(.success(outputURL))
            case .failed, .cancelled:
                if let error = exportSession.error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "Conversion Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                }
            default:
                break
            }
        }
    }
    
    func playAudio() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if let url = compressedAudioRecordUrl {
                do {
                    if AVAudioSession.sharedInstance().category != .playback {
                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                        try AVAudioSession.sharedInstance().setActive(true)
                    }
                        
                    self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                    self.audioPlayer.play()
                    print("Playing recording")
                } catch {
                    print("Error playing recording: \(error.localizedDescription)")
                }
            }
            
//            if let audioFile = audioFile {
//                do {
//                    Logger.logInfo("Audio Size: \(audioFile.length) bytes")
//                    self.engine.attach(self.playerNode)
//                    let mixerNode = self.engine.mainMixerNode
//                    self.engine.connect(self.playerNode, to:mixerNode, format: audioFile.processingFormat)
//                    self.playerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
//                    self.engine.prepare()
//                    
//                    do {
//                        try self.engine.start()
//                    } catch {
//                        
//                    }
//                    
//                    self.playerNode.play()
//                } catch {
//                    
//                }
//            }
        }
        
    }
}
