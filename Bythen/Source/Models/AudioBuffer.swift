//
//  AudioBuffer.swift
//  Bythen
//
//  Created by edisurata on 17/09/24.
//

import AVFoundation

struct AudioBuffer {
    
    var buffer: AVAudioPCMBuffer?
    var power: Float = 0
    var amplitude: Float = 0
    var threshold: Float = 0
}
