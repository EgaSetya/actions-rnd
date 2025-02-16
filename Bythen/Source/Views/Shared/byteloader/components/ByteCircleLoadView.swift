//
//  ByteCircleLoadView.swift
//  Bythen
//
//  Created by Darindra R on 03/10/24.
//

import SwiftUI

struct ByteCircleLoadView: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            ForEach(0 ..< 4) { index in
                Circle()
                    .frame(width: 21.5, height: 21.5)
                    .foregroundColor(.black)
                    .offset(x: 21.5, y: 0)
                    .rotationEffect(.degrees(Double(index) * 90))
            }
        }
        .rotationEffect(.degrees(rotation))
        .scaleEffect(scale)
        .onAppear {
            startAnimating()
        }
    }

    private func startAnimating() {
        withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
            rotation = 360
        }

        syncScaleWithRotation()
    }

    private func syncScaleWithRotation() {
        withAnimation(Animation.easeInOut(duration: 1)) {
            scale = 1.5
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(Animation.easeInOut(duration: 1)) {
                scale = 1.0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            syncScaleWithRotation()
        }
    }
}
