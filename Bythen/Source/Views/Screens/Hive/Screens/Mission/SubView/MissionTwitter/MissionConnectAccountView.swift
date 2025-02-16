//
//  MissionConnectAccountView.swift
//  Bythen
//
//  Created by Darul Firmansyah on 22/01/25.
//

import SwiftUI

struct MissionConnectAccountView: View {
    let onConnectTapped: (() -> Void)
    let onGoBackTapped: (() -> Void)
    var body: some View {
        Group {
            VStack(spacing: 0) {
                if let image = UIImage(named: "mission-cover-small") {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .clipped()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    if let image = UIImage(named: "mission-title") {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 13)
                    }
                    
                    Text("Start your journey and begin earning rewards like nectars, honey, and crypto.")
                        .lineLimit(2)
                        .font(FontStyle.foundersGrotesk(.regular, size: 14))
                        .lineSpacing(0)
                        .foregroundStyle(Color.ghostWhite800)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 13)
                
                VStack(alignment: .leading, spacing: 12) {
                    Button {
                        onConnectTapped()
                    } label: {
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 48)
                            .overlay {
                                Text("Connect X".uppercased())
                                    .font(FontStyle.foundersGrotesk(.semibold, size: 16))
                                    .foregroundStyle(Color.byteBlack)
                            }
                            .overlay(alignment: .trailing) {
                                Image(uiImage: UIImage(systemName: "arrow.forward")!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 14, height: 14)
                                    .padding(.trailing, 16)
                            }
                    }
                    
                    Button {
                        onGoBackTapped()
                    } label: {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 48)
                            .overlay {
                                Text("Back To My Hive".uppercased())
                                    .font(FontStyle.foundersGrotesk(.semibold, size: 16))
                                    .foregroundStyle(.white)
                            }
                            .border(Color.ghostWhite600, width: 1)
                    }
                }
                .padding(.horizontal, 13)
                .padding(.top, 48)
                .padding(.bottom, 16)
                
                HStack(alignment: .center, spacing: 12) {
                    if let image = UIImage(named: "twitter") {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                    Text("X account is required for mission verification.")
                        .font(FontStyle.neueMontreal(.regular, size: 14))
                        .foregroundStyle(Color.white)
                        .lineLimit(8)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.all, 13)
                .background(Color.sonicBlue700)
            }
            .background(Color(hex: "#0E100F"))
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding(.horizontal, 16)
    }
}
