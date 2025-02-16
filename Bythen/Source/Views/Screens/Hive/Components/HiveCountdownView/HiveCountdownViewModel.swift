//
//  HiveCountdownViewModel.swift
//  Bythen
//
//  Created by erlina ng on 27/12/24.
//

import SwiftUI

class HiveCountdownViewModel: ObservableObject {
    @Published var formattedTime: String = ""
    private var remainingSeconds: Int = 0
    private var timer: Timer?

    init(seconds: Int) {
        startCountdown(from: seconds)
    }

    private func startCountdown(from seconds: Int) {
        remainingSeconds = seconds
        updateFormattedTime()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.remainingSeconds <= 0 {
                self.timer?.invalidate()
                self.timer = nil
                self.formattedTime = "0D: 0H: 0M"
            } else {
                self.remainingSeconds -= 1
                self.updateFormattedTime()
            }
        }
    }

    private func updateFormattedTime() {
        let days = remainingSeconds / (24 * 60 * 60)
        let hours = (remainingSeconds % (24 * 60 * 60)) / (60 * 60)
        let minutes = (remainingSeconds % (60 * 60)) / 60

        formattedTime = "\(days)D: \(hours)H: \(minutes)M"
    }

    deinit {
        timer?.invalidate()
    }
}
