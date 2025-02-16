//
//  ByteLoadProgressView.swift
//  Bythen
//
//  Created by Darindra R on 03/10/24.
//

import Combine
import SwiftUI

struct ByteLoadProgressView: View {
    @Binding var isCompleted: Bool
    @Binding var byteName: String
    @State private var progress: Double = 0.0
    @State private var timerCancellable: AnyCancellable?

    let completion: () -> Void

    var body: some View {
        VStack(spacing: 22) {
            ProgressView(value: progress, total: 1)
                .progressViewStyle(LinearProgressViewStyle(tint: .black))
                .frame(height: 3)

            HStack(alignment: .center, spacing: 8) {
                Image(AppImages.kFastForwardIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)

                Text("LOADING - \(Int(progress * 100))%")
                    .font(FontStyle.dmMono(.medium, size: 11))

                Spacer(minLength: 0)

                if byteName != "" {
                    Text("Starting Chat with \(byteName.capitalized)...")
                        .font(FontStyle.dmMono(.medium, size: 11))
                }
            }
        }
        .onAppear {
            startProgressPublisher()
        }
        .onDisappear {
            stopProgressPublisher()
        }
    }

    private func startProgressPublisher() {
        timerCancellable = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if progress < (isCompleted ? 1 : 0.95) {
                    if (progress + 0.01) < 1 {
                        progress += 0.01
                    } else {
                        progress = 1
                    }

                }
                if progress >= 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        stopProgressPublisher()
                        completion()
//                        isCompleted = false
                        progress = 0.0
                    }
                }
            }
    }

    // Function to stop the Combine publisher
    private func stopProgressPublisher() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
