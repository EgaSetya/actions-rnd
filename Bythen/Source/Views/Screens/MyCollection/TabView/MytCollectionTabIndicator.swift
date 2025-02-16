//
//  MytCollectionTabIndicator.swift
//  Bythen
//
//  Created by edisurata on 13/09/24.
//

import SwiftUI

struct MyCollectionTabIndicator: View {
    @Environment(\.colorScheme) var theme

    @Binding var pageIndicatorIdx: Int
    var titles: [String]
    @State var pageIndicatorOffset: CGFloat = 0.0
    @State var indicatorWdith: CGFloat = 0.0
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Array(titles.enumerated()), id: \.element) { idx, title in
                    Button {
                        withAnimation {
                            pageIndicatorIdx = idx
                        }
                    } label: {
                        Text(title)
                            .frame(maxWidth: .infinity)
                            .font(FontStyle.foundersGrotesk(.semibold, size:16))
                            .foregroundColor(ByteColors.foreground(for: theme))
                            .opacity(idx == pageIndicatorIdx ? 1 : 0.4)
                    }
                }
            }
            .padding([.leading, .trailing])
            
            GeometryReader { geo in
                HStack {
                    Rectangle()
                        .fill(ByteColors.foreground(for: theme))
                        .offset(x: CGFloat(pageIndicatorIdx) * indicatorWdith)
                        .frame(maxWidth: indicatorWdith , maxHeight: 1)
                        .animation(.linear(duration: 0.2), value: CGFloat(pageIndicatorIdx) * indicatorWdith)
                    
                    Spacer()
                }
                .background(
                    Rectangle()
                        .fill(ByteColors.foreground(for: theme))
                        .opacity(0.4)
                        .frame(maxWidth: .infinity, maxHeight: 1)
                )
                .onAppear(perform: {
                    indicatorWdith = geo.size.width / CGFloat(titles.count)
                })
            }
            .frame(height: 2)
            .padding([.leading, .trailing])
            
        }
    }
}

#Preview {
    @State var tab: Int = 0
    
    return VStack {
        MyCollectionTabIndicator(pageIndicatorIdx: $tab, titles: ["BYTE", "INFO", "SUMMARY", "ZOOM"])
            .background(.red)
    }.background(.green)
}
