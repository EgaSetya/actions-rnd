//
//  PerformanceMonitoringHelper.swift
//  Bythen
//
//  Created by Ega Setya on 15/01/25.
//

import Foundation
import FirebasePerformance

enum PerformanceMonitoring: String, CaseIterable {
    case voiceChat
    case voiceChatApiCall
}

extension PerformanceMonitoring {
    func startTracing() -> Trace? {
        Performance.startTrace(name: self.rawValue.snakeCased()?.uppercased() ?? "")
    }
}
