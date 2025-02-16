//
//  ByteSummaryView.swift
//  Bythen
//
//  Created by edisurata on 03/09/24.
//

import SwiftUI

struct ByteSummaryView: View {
    
    @StateObject var viewModel: ByteSummaryViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            PersonalityRadarView(
                dataPoints: viewModel.dataPoints, // Your data points, scaled to 1.0
                labels: viewModel.dataLabels,    // Labels for each axis
                maxValue: 1.0
            )
            .frame(maxWidth: .infinity, maxHeight: 250)
            
            ByteProfileView(
                profileInfo: $viewModel.profileInfo,
                role: $viewModel.role,
                xp: $viewModel.xp,
                memories: $viewModel.memories,
                knowledge: $viewModel.knowledge
            )
            .padding()
            
            Spacer()
        }
        .background(.clear)
    }
}

#Preview {
    ByteSummaryView(viewModel: ByteSummaryViewModel(profileInfo: "Male / 22y", role: "Assitant", xp: "1234", memories: "1235", knowledge: "1236", dataPoints: [0.2, 0.70, 0.2, 0.8, 0.8, 0.6], dataLabels: [
        "Conventional",
        "Extravert",
        "Lively",
        "Spontaneous",
        "Emphathetic",
        "Agreeable"
    ]))
        .background(.green)
}
