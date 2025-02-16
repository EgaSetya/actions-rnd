//
//  MissionButtonsView.swift
//  Bythen
//
//  Created by Darul Firmansyah on 03/01/25.
//

import SwiftUI

struct MissionButtonsView: View {
    let state: MissionButtonsState
    let goToPost: (() -> Void)
    let verify: (() -> Void)
    
    var body: some View {
        switch state {
        case .hidden:
            EmptyView()
        default:
            HStack(spacing: 12) {
                Button {
                    goToPost()
                } label: {
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 36)
                        .overlay {
                            Text("Go To Post".uppercased())
                                .font(FontStyle.foundersGrotesk(.semibold, size: 14))
                                .foregroundStyle(.black)
                        }
                }
                
                Button {
                    if state != .verifying {
                        verify()
                    }
                } label: {
                    Rectangle()
                        .fill(state.verifyButtonColor)
                        .frame(height: 36)
                        .overlay {
                            Text("Verify".uppercased())
                                .font(FontStyle.foundersGrotesk(.semibold, size: 14))
                                .foregroundStyle(state.verifyButtonTitleColor)
                        }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
