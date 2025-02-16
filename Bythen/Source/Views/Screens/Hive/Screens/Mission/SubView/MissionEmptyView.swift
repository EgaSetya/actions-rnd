//
//  MissionEmptyView.swift
//  Bythen
//
//  Created by Darul Firmansyah on 23/01/25.
//

import SwiftUI

struct MissionEmptyView: View {
    var body: some View {
        VStack(spacing: 30) {
            if let image = UIImage(named: "mission_folder") {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 72, height: 63)
            }
            
            VStack(spacing: 6) {
                Text("Mission Accomplished!")
                    .font(Font.custom("NeueMontreal-Medium", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.white)
                
                Text("All missions are completed. Stay tuned for more.")
                    .font(Font.custom("NeueMontreal-Semibold", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.gray)
                    .lineLimit(2)
            }
        }
        .padding()
        .background {
            // Background texture
            if let image = UIImage(named: "mission_empty_texture") {
                Image(uiImage: image)
                    .resizable()
            }
        }
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}
