//
//  VoiceTagChip.swift
//  Bythen
//
//  Created by edisurata on 14/10/24.
//

import SwiftUI

struct VoiceTagChip: View {
    @Environment(\.colorScheme) var theme
    @StateObject var viewModel: VoiceTagChipVM
    
    var body: some View {
        Button(action: viewModel.tapAction) {
            Text(viewModel.label)
                .foregroundStyle(viewModel.isSelected ? .byteBlack : ByteColors.foreground(for: theme))
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .font(FontStyle.foundersGrotesk(.semibold, size: 14))
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    viewModel.isSelected ? ByteColors.highlightOrange(for: theme) : ByteColors.background(for: theme),
                    strokeBorder: viewModel.isSelected ? ByteColors.foreground(for: theme) : ByteColors.foreground(for: theme).opacity(0.7),
                    lineWidth: viewModel.isSelected ? 2 : 1
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.trailing, 8)
        .padding(.top, 8)
    }
}
