//
//  MissionCountdownView.swift
//  Bythen
//
//  Created by Darul Firmansyah on 13/01/25.
//

import SwiftUI

struct MissionCountdownView: View {
    let countdown: Int
    
    var body: some View {
        Text(formattedTime(from: countdown))
            .font(FontStyle.dmMono(.medium, size: 12))
            .foregroundStyle(.white)
            .padding(.all, 6)
        .background(Color.elmoRed500)
        .clipShape(Capsule(style: .circular))
    }

    private func formattedTime(from seconds: Int) -> String {
        let secondsInDay = 86400
        let days = seconds / secondsInDay
        let hours = (seconds % secondsInDay) / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        
        if days > 0 {
            return String(format: "%02d:%02d:%02d:%02d", days, hours, minutes, seconds)
        } else if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
