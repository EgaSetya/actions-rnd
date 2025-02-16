//
//  MissionObjectivesView.swift
//  Bythen
//
//  Created by Darul Firmansyah on 03/01/25.
//

import SwiftUI

struct MissionObjectivesView: View {
    let missionDetailVM: MissionDetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(missionDetailVM.missionObjective, id: \.self) { objective in
                HStack(alignment: .center) {
                    HStack(spacing: 6) {
                        if let iconURLString = objective.iconURLString {
                            CachedAsyncImage(urlString: iconURLString)
                                .frame(width: 16, height: 16)
                        }
                        else if let defaultImage = UIImage(named: objective.defaultImageName) {
                            Image(uiImage: defaultImage)
                                .frame(width: 16, height: 16)
                        }
                        
                        Text(objective.objectiveTitle)
                            .font(FontStyle.neueMontreal(.medium, size: 14))
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .center, spacing: 6) {
                        switch objective.state {
                        case .notStarted:
                            EmptyView()
                        case .verifying:
                            MissionCircularProgressView()
                            Text("Verifying")
                                .font(FontStyle.dmMono(.medium, size: 11))
                                .foregroundStyle(.white)
                        case .completed:
                            Image("circle-check")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(Color.green)
                                .frame(width: 12, height: 12)
                            
                            Text("Completed")
                                .font(FontStyle.dmMono(.medium, size: 11))
                                .foregroundStyle(.white)
                        case .incomplete:
                            Image("circle-exclamation-point")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(Color.red)
                                .frame(width: 12, height: 12)
                            
                            Text("Incomplete")
                                .font(FontStyle.dmMono(.medium, size: 11))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.all, 6)
                    .clipShape(Capsule(style: .circular))
                    .overlay(Capsule(style: .circular)
                        .stroke(objective.state != .notStarted ? Color.ghostWhite200 : .clear, lineWidth: 1)
                    )
                }
                .padding(.all, 14)
                .frame(maxWidth: .infinity)
                
                Rectangle()
                .fill(Color.ghostWhite200)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(
            RoundedRectangle(cornerRadius: 4).stroke(Color.ghostWhite200, lineWidth: 1)
        )
    }
}
