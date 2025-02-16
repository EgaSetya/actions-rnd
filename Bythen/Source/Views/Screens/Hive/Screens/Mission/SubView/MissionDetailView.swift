//
//  MissionDetailView.swift
//  Bythen
//
//  Created by Darul Firmansyah on 03/01/25.
//

import SwiftUI

struct MissionDetailView: View {
    @ObservedObject
    var missionDetailVM: MissionDetailViewModel
    let goToPost: (() -> Void)
    let verify: (() -> Void)
    
    var body: some View {
        Group {
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 16) {
                    CachedAsyncImage(urlString: missionDetailVM.imageURLString)
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    
                    Text(missionDetailVM.content)
                        .font(FontStyle.neueMontreal(.regular, size: 12))
                        .foregroundStyle(Color.white)
                        .lineLimit(8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.all, 16)
                .background(Color.ghostWhite200)
                
                VStack {
                    HStack(alignment: .center) {
                        Text(missionDetailVM.objectiveTitle)
                            .lineLimit(1)
                            .font(FontStyle.foundersGrotesk(.semibold, size: 16))
                            .foregroundStyle(.white)
                        
                        countdownView
                        
                        Spacer()
                        
                        HStack(spacing: 6) {
                            Image("nectar-icon")
                                .resizable()
                                .colorMultiply(.red)
                                .frame(width: 16, height: 16)
                            
                            Text(missionDetailVM.earnedNectarDesc)
                                .font(FontStyle.foundersGrotesk(.semibold, size: 12))
                                .foregroundStyle(.white)
                        }
                        .padding(.all, 6)
                        .background(Color.ghostWhite200)
                        .clipShape(Capsule(style: .circular))
                    }
                    .padding(.all, 16)
                    
                    Group {
                        MissionObjectivesView(missionDetailVM: missionDetailVM)
                        MissionButtonsView(state: missionDetailVM.buttonState) {
                            goToPost()
                        } verify: {
                            verify()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .background(Color.ghostWhite100)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    var countdownView: some View {
        if missionDetailVM.missionCountdown > 0 {
            MissionCountdownView(countdown: missionDetailVM.missionCountdown)
        }
    }
}

