//
//  ByteCardView.swift
//  Bythen
//
//  Created by edisurata on 02/09/24.
//

import SwiftUI

struct DiagonalCutShape: Shape {
    var cutLength: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cutLength))
        path.addLine(to: CGPoint(x: rect.width - cutLength, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()

        return path
    }
}

struct ByteCardView: View {
    @Environment(\.colorScheme) var theme
    
    var imageName: String
    var isPrimary: Bool = false
    var isSelected: Bool = false
    var isTrial: Bool = false
    @State private var containerWidth: CGFloat = 100
    @State private var containerHeight: CGFloat = 80
    @State private var cutLength: CGFloat = 10
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CachedAsyncImage(urlString: imageName)
                    .frame(maxWidth: containerWidth, maxHeight: containerHeight)
                
                if isPrimary && !isSelected {
                    HStack {
                        Image("star")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(ByteColors.foreground(for: theme))
                            .padding(6)
                            .background(ByteColors.background(for: theme).opacity(0.3))
                            .clipShape(Circle())
                            .padding(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                } else if isTrial && !isSelected {
                    HStack {
                        Image("timer.fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(ByteColors.foreground(for: theme))
                            .padding(6)
                            .background(ByteColors.background(for: theme).opacity(0.3))
                            .clipShape(Circle())
                            .padding(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                
                if isSelected {
                    VStack(spacing: 0) {
                        HStack(spacing: 2) {
                            Text(getSelectedLabelText())
                                .font(FontStyle.dmMono(.medium, size: 8))
                                .foregroundColor(.gokuOrange600)
                                .padding(.leading, 10)
                            
                            if isPrimary {
                                Image("star")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 8, height: 8)
                                    .rotationEffect(.degrees(90))
                                    .foregroundStyle(.gokuOrange600)
                            } else if isTrial {
                                Image("timer.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 8, height: 8)
                                    .rotationEffect(.degrees(90))
                                    .foregroundStyle(.gokuOrange600)
                            }
                            
                            Spacer()
                        }.padding(0)
                    }
                    .frame(maxWidth: containerHeight, maxHeight: 16).background(ByteColors.foreground(for: theme))
                    .padding(0)
                    .rotationEffect(.degrees(-90))
                    .offset(x: -1*containerWidth/2 + 8)
                }
            }
            .background(ByteColors.foreground(for: theme).opacity(0.5))
            .frame(width: containerWidth, height: containerHeight)
            .clipShape(DiagonalCutShape(cutLength: cutLength))
            .overlay(getViewShape())
            .onAppear {
                containerWidth = geometry.size.width
                containerHeight = containerWidth * 2 / 3
                cutLength = containerWidth / 10
            }
        }
    }
    
    private func getViewShape() -> some View {
        let strokeColor: Color = ByteColors.foreground(for: theme)
        var lineWidth: CGFloat = 1
        var opacity: CGFloat = 0.5
        
        if isSelected {
            lineWidth = 2
            opacity = 1
        }
        
        return DiagonalCutShape(cutLength: cutLength)
            .stroke(strokeColor, lineWidth: lineWidth)
            .opacity(opacity)
    }
    
    private func getSelectedLabelText() -> String {
        if isPrimary {
            return "PRIMARY"
        } else if isTrial {
            return "TRIAL"
        }
        
        return "OWNED"
    }
}

#Preview {
    return VStack {
        ByteCardView(imageName: "mock-card-azuki", isPrimary: false, isSelected: true, isTrial: true)
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 80)
            .padding()
    }.background(.green)
}
