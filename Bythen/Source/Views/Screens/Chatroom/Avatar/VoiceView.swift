//
//  VoiceView.swift
//  Bythen
//
//  Created by edisurata on 14/09/24.
//

import SwiftUI

struct VoiceView: View {
    
    let animateDots = [
        [
            "duration": 0.6,
            "delay": 0.2
        ],
        [
            "duration": 0.3,
            "delay": 0.4
        ],
        [
            "duration": 0.4,
            "delay": 0.3
        ]
    ]
//    @Binding var animate: Bool
    @Binding var voicePower: [Double]
    @State var isAnimateLoading: Bool
    var foregroundColor: Color = .appBlack
    var voiceSpeed: CGFloat = 1
    @State private var animate: Bool = false
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<animateDots.count, id: \.self) { idx in
                if isAnimateLoading {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(foregroundColor)
                        .frame(width: 6, height: 6)
                        .offset(y: animate ? 0 : -3)
                        .animation(
                            Animation
                                .easeInOut(duration: 0.5)
                                .repeatForever()
                                .delay(0.1 * Double(idx)),
                            value: animate
                        )
                        .onAppear {
                            animate = true
                        }
                    
                } else {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(foregroundColor)
                        .frame(width: 6, height: min(max(6 + voicePower[idx] * 14, 6), 20))
                        .animation(Animation.easeInOut, value: voicePower)
                }
            }
        }
        .frame(maxHeight: 24)
    }
}

#Preview {
    
    return VStack {
        VoiceView(voicePower: .constant([-20.0,1.0,1.0]), isAnimateLoading: false)
    }
    .background(.green)
}
