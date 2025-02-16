//
//  MissionCircularProgressView.swift
//  Bythen
//
//  Created by Darul Firmansyah on 20/01/25.
//

import SwiftUI

struct MissionCircularProgressView: View {
    @State
    var rotation: Double = 0
    var body: some View {
        if let image = UIImage(named: "mission_verifying") {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 10, height: 10)
                .rotationEffect(.degrees(rotation))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: rotation)
            
                .onAppear {
                    rotation = 360
                }
        }
    }
}
