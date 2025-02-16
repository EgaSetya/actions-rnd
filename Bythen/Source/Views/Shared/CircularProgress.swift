//
//  ProgressCircularView.swift
//  Bythen
//
//  Created by edisurata on 30/08/24.
//

import SwiftUI

struct CircularProgress: View {
    @State private var isAnimating: Bool = false
    var successIconName: String = "wallet-connected"
    var progressIconName: String = "metamask"
    @Binding var isSuccess: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .frame(width: 90, height: 90)
                .foregroundColor(isSuccess ? .black : Color(hex: "#0E100F1A"))
            
            if !isSuccess {
                
                Circle()
                    .trim(from: 0.0, to: 0.5)
                    .stroke(lineWidth: 5)
                    .frame(width: 90, height: 90)
                    .foregroundColor(.black)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .onAppear {
                        withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                            isAnimating = true
                        }
                    }
            }
            
            if isSuccess {
                Image(successIconName)
            } else {
//                Image(progressIconName)
            }
        }
        
    }
}

#Preview {
    @State var isSuccess = false
    
    return CircularProgress(isSuccess: $isSuccess)
}
