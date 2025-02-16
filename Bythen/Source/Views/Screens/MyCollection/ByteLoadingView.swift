//
//  ByteLoadingView.swift
//  Bythen
//
//  Created by edisurata on 12/09/24.
//

import SwiftUI

struct ShimmeringRectangle: View {
    var width: CGFloat
    var height: CGFloat
    
    @State private var animate = false

    var body: some View {
        ZStack {
            Color.white.opacity(0.1) // Base color for the loading placeholder
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.gray.opacity(0.1),
                    Color.white.opacity(0.3),
                    Color.white.opacity(0.5),
                    Color.white.opacity(0.3),
                    Color.gray.opacity(0.1)]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .mask(
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .offset(x: animate ? width : -1 * width) // Moving the gradient from top to bottom
            )
        }
        .frame(width: width, height: height) // Size of the rectangle
        .cornerRadius(4) // Optional rounded corners for a smoother look
        .onAppear {
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                animate.toggle()
            }
        }
    }
}

struct ByteLoadingView: View {
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack {
                    ShimmeringRectangle(width: 60, height: 16)
                        .padding([.leading, .trailing])
                    Spacer()
                }.padding(.top, 110)
                HStack {
                    ShimmeringRectangle(width: 113, height: 36)
                        .padding([.leading, .trailing])
                        .padding(.top, 10)
                    Spacer()
                }
                
                Spacer()
                
                ShimmeringRectangle(width: geo.size.width - 40, height: 36)
                    .padding([.leading, .trailing])
                ShimmeringRectangle(width: geo.size.width - 40, height: 48)
                    .padding([.leading, .trailing])
                    .padding(.bottom, 150)
                    .padding(.top, 20)
            }
        }
    }
}

#Preview {
    ByteLoadingView().background(.appBlack)
}
