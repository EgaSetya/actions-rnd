//
//  ChatSearchShimmerView.swift
//  Bythen
//
//  Created by Darindra R on 10/10/24.
//

import SwiftUI

struct ChatSearchShimmerView: View {
    @State
    private var shimmerActive = false

    var body: some View {
        HStack(spacing: 8) {
            Image(AppImages.kBrowsingIcon)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.appBlack.opacity(0.5))
                .frame(width: 24, height: 24)

            Text("Browsing...")
                .font(FontStyle.neueMontreal(.medium, size: 16))
                .foregroundStyle(.appBlack.opacity(0.5))
        }
        .overlay(
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, Color.white.opacity(0.5), .clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .rotationEffect(.degrees(30))
                .offset(x: shimmerActive ? 300 : -300)
        )
        .mask(
            HStack(spacing: 8) {
                Image(AppImages.kBrowsingIcon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.appBlack.opacity(0.5))
                    .frame(width: 24, height: 24)

                Text("Browsing...")
                    .font(FontStyle.neueMontreal(.medium, size: 16))
                    .foregroundStyle(.appBlack.opacity(0.5))
            }
        )
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                shimmerActive = true
            }
        }
        .frame(height: 36)
    }
}
