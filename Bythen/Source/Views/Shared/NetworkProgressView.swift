//
//  ProgressView.swift
//  Bythen
//
//  Created by edisurata on 04/09/24.
//

import SwiftUI

struct NetworkProgressView: View {
    var size = 80.0
    var lineWidth = 10.0
    @State var bgColor: Color = .clear
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            VStack {
                Circle()
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.white, .white.opacity(0.8), .white.opacity(0.5), .white.opacity(0.3)]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(rotation))
                    .frame(width: size, height: size)
                    .onAppear {
                        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                            rotation = 360
                        }
                    }
            }
            .frame(width: 150, height: 150)
            .background(RoundedRectangle(cornerRadius: 16).fill(bgColor))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.clear)
    }
}

struct ProgressOverlayModifier: ViewModifier {
    let isPresented: Bool
    var bgColor: Color = .clear
    
    func body(content: Content) -> some View {
        content.overlay {
            if isPresented {
                // Background overlay to dim the underlying view
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                // Circular progress view
                NetworkProgressView(bgColor: bgColor)
            }
        }
    }
}

#Preview {
    NetworkProgressView(bgColor: .byteBlack.opacity(0.5))
        .background(.green)
}
