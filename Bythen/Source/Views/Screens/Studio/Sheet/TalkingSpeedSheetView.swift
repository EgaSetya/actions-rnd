//
//  TalkingSpeedSheetView.swift
//  Bythen
//
//  Created by Darindra R on 11/11/24.
//

import SwiftUI

struct TalkingSpeedSheetView: View {
    @State
    private var speed: Double = 0

    let initialSpeed: Double
    let onChange: (Double) -> Void
    let onCancel: () -> Void

    init(
        initialSpeed: Double,
        onChange: @escaping (Double) -> Void,
        onCancel: @escaping () -> Void
    ) {
        speed = initialSpeed * 2
        self.initialSpeed = initialSpeed
        self.onChange = onChange
        self.onCancel = onCancel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .center) {
                Text("TALKING SPEED")
                    .font(FontStyle.foundersGrotesk(.semibold, size: 20))
                    .foregroundStyle(.white)

                Spacer()

                Button(
                    action: {
                        onCancel()
                    }
                ) {
                    Image(systemName: "xmark")
                        .frame(width: 24, height: 24)
                }
                .tint(.white)
            }

            VStack {
                HStack {
                    Text("Slow (0.5x)")
                        .font(FontStyle.dmMono(.regular, size: 14))
                        .foregroundStyle(.white)

                    Spacer()

                    Text("Fast (1.5x)")
                        .font(FontStyle.dmMono(.regular, size: 14))
                        .foregroundStyle(.white)
                }

                StepSlider(
                    value: $speed,
                    initialValue: initialSpeed * 2,
                    range: 0 ... 3,
                    trackHeight: 2
                ).frame(height: 56)
            }
        }
        .padding(.all, 16)
        .background(.byteBlack)
        .cornerRadius(8, corners: [.topLeft, .topRight])
        .onDisappear {
            onChange(speed / 2)
        }
    }
}
