//
//  VoiceSampleView.swift
//  Bythen
//
//  Created by edisurata on 14/10/24.
//

import SwiftUI

struct VoiceSampleView: View {
    @Environment(\.colorScheme) var theme
    @StateObject var viewModel: VoiceSampleVM
    
    var body: some View {
        Button(action: viewModel.tapAction) {
            HStack(spacing: 0) {
                Text(viewModel.name)
                    .font(FontStyle.foundersGrotesk(.semibold, size: 16))
                    .foregroundStyle(viewModel.isSelected ? .appBlack : ByteColors.foreground(for: theme))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                if viewModel.isPlayingAudio {
                    VoiceView(voicePower: $viewModel.voicePowers, isAnimateLoading: false)
                        .padding(.horizontal, 14)
                } else {
                    Image("brand-awareness.fill")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 17, height: 16)
                        .foregroundStyle(viewModel.isSelected ? .appBlack : ByteColors.foreground(for: theme))
                        .padding(.trailing, 11.5)
                }
            }
            .frame(height: 80, alignment: .top)
            .background(
                Group {
                    if viewModel.isSelected {
                        Rectangle()
                            .fill(ByteColors.highlightOrange(for: theme), strokeBorder: ByteColors.foreground(for: theme), lineWidth: 2)
                    } else {
                        Rectangle()
                            .fill(ByteColors.background(for: theme), strokeBorder: ByteColors.foreground(for: theme), lineWidth: 1)
                    }
                }
            )
        }
    }
}
