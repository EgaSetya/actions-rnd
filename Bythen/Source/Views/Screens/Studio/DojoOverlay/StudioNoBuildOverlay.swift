//
//  StudioNoBuildOverlay.swift
//  Bythen
//
//  Created by edisurata on 12/11/24.
//

import SwiftUI

struct StudioNoBuildOverlay: View {
    
    @State private var isShowTicker: Bool = true
    
    var buildByteAction: () -> Void = { }
    
    var body: some View {
        VStack {
            if isShowTicker {
                HStack {
                    Image("info.fill")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.byteBlack)
                        .padding(12)
                        .padding(8)
                    Text("You need to build your bytes before using the director’s mode")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.byteBlack)
                        .font(FontStyle.neueMontreal(size: 12))
                        .lineSpacing(4)
                        .padding(.vertical, 6)
                        .padding(.vertical, 5)
                    
                    Color.byteBlack.opacity(0.1)
                        .frame(maxWidth: 1)
                        .padding(.vertical, 8)
                    
                    Button {
                        isShowTicker = false
                    } label: {
                        Image("close")
                            .resizable()
                            .frame(width: 11, height: 11)
                            .foregroundStyle(.byteBlack)
                            .padding(24)
                    }

                }
                .frame(maxWidth: .infinity, maxHeight: 69)
                .background(.gokuOrange100)
                .padding(.top, 16)
            }

            Spacer()
            
            Button {
                buildByteAction()
            } label: {
                HStack {
                    Text("BUILD BYTES")
                        .font(.foundersGrotesk(.semibold, size: 16))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                }
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.gokuOrange600)
                )
                .frame(maxHeight: 48)
            }
        }
        .padding(.all, 16)
    }
}

#Preview {
    StudioNoBuildOverlay()
}
