//
//  AudioPlayer.swift
//  Bythen
//
//  Created by edisurata on 14/10/24.
//

import AVFoundation
import Combine

protocol AudioPlayerProtocol {
    func playAudioFromRemoteURL(_ url: String)
    func playAudio(from url: URL)
    func stop()
    
    var playingAudioBufferSignal: AnyPublisher<(Double, Bool), Never> { get }
}

class AudioPlayer: AudioPlayerProtocol {
    var audioEngine: AVAudioEngine!
    var playerNode: AVAudioPlayerNode!
    
    private var playingAudioBufferSubject = PassthroughSubject<(Double, Bool), Never>()
    var playingAudioBufferSignal: AnyPublisher<(Double, Bool), Never> {
        get {
            return playingAudioBufferSubject.eraseToAnyPublisher()
        }
    }
    private var isPlaying: Bool = false
    
    func playAudioFromRemoteURL(_ url: String) {
        guard let audioURL = URL(string: url) else {
            print("Invalid URL")
            return
        }
        self.downloadAudio(from: audioURL) { [weak self] downloadedUrl in
            guard let self else { return }
            guard let downloadedUrl = downloadedUrl else { return }
            self.playAudio(from: downloadedUrl)
        }
    }
    
    func playAudio(from url: URL) {
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        
        audioEngine.attach(playerNode)
        
        do {
            self.isPlaying = true
            let audioFile = try AVAudioFile(forReading: url)
            let mainMixer = audioEngine.mainMixerNode
            audioEngine.connect(playerNode, to: mainMixer, format: audioFile.processingFormat)
            
            // Install a tap on the mixer node to get the audio data
            mainMixer.installTap(onBus: 0, bufferSize: 1024, format: mainMixer.outputFormat(forBus: 0)) { (buffer, when) in
                self.processAudioBuffer(buffer)
            }
            
            try audioEngine.start()
            playerNode.scheduleFile(audioFile, at: nil, completionHandler: {
                let mainMixer = self.audioEngine.mainMixerNode
                mainMixer.removeTap(onBus: 0)
                self.isPlaying = false
                self.playingAudioBufferSubject.send((0, true))
            })
            playerNode.play()
            
        } catch {
            print("Audio file error: \(error)")
        }
    }
    
    // Function to process the audio buffer and calculate the amplitude
    func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData else { return }
        
        let channelDataValue = channelData.pointee
        let frameLength = Int(buffer.frameLength)
        
        var rms: Float = 0.0
        
        // Calculate RMS (Root Mean Square) for amplitude
        for frame in 0..<frameLength {
            rms += channelDataValue[frame] * channelDataValue[frame]
        }
        rms = sqrt(rms / Float(frameLength))
        
        // Convert RMS to amplitude (0.0 - 1.0 range)
        let amplitude = min(max(rms * 3, 0.0), 1.0)
        
        // Output the amplitude
        print("Amplitude: \(amplitude)")
        self.playingAudioBufferSubject.send((Double(amplitude), false))
    }
    
    func stop() {
        if self.isPlaying {
            playerNode.stop()
            let mainMixer = audioEngine.mainMixerNode
            mainMixer.removeTap(onBus: 0)
            audioEngine.stop()
            self.playingAudioBufferSubject.send((0, true))
        }
    }
    
    private func downloadAudio(from url: URL, completion: @escaping (URL?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
            guard let localURL = localURL else {
                print("Error downloading file: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            completion(localURL)
        }
        task.resume()
    }
}
