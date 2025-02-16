//
//  ScreenRecorder.swift
//  Bythen
//
//  Created by edisurata on 23/10/24.
//

import SwiftUI
import ReplayKit

protocol ScreenRecorderProtocol {
    func startRecording(success: @escaping () -> Void, failure: @escaping (Error) -> Void) -> Void
    func stopRecording(completion: @escaping (URL?) -> Void) -> Void
}

class ScreenRecorder: ScreenRecorderProtocol {
    let recorder = RPScreenRecorder.shared()

    func startRecording(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        guard recorder.isAvailable else {
            print("Recording is not available")
            return
        }
        
        // Start recording with audio from the app's output (not the microphone)

        recorder.startRecording(withMicrophoneEnabled: false) { error in
            if let error = error {
                print("Error starting recording: \(error.localizedDescription)")
                failure(error)
            } else {
                print("Recording started successfully.")
                success()
            }
        }
    }

    func stopRecording(completion: @escaping (URL?) -> Void) {
        let randomString = UUID().uuidString
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(randomString + ".mov")
        
        recorder.stopRecording(withOutput: fileURL) { error in
            if let error = error {
                print("Error stopping recording: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            completion(fileURL)
        }
    }
}
