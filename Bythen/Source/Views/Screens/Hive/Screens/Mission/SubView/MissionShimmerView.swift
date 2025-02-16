//
//  MissionShimmerView.swift
//  Bythen
//
//  Created by Darul Firmansyah on 30/01/25.
//

import SwiftUI

struct MissionListShimmerView: View {
    var body: some View {
        LazyVStack(spacing: 8) {
            ForEach(0 ..< 4) { _ in
                Rectangle()
                    .fill(.byteBlack.opacity(0.5))
                    .overlay{
                        GeometryReader { geo in
                            ShimmeringRectangle(width: geo.size.width, height: 80)
                        }
                        
                    }
                    .frame(height: 80)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct MissionScreenShimmerView: View {
    var body: some View {
        GeometryReader { geo in
            LazyVStack(spacing: 8) {
                ShimmeringRectangle(width: geo.size.width, height: 180)
                ForEach(0 ..< 4) { _ in
                    Rectangle()
                        .fill(.byteBlack)
                        .overlay{
                            ShimmeringRectangle(width: geo.size.width, height: 80)
                        }
                    
                }
                .frame(height: 80)
            }
        }
        .padding(.horizontal, 16)
    }
}

