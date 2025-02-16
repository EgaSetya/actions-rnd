//
//  ByteSelectionView.swift
//  Bythen
//
//  Created by edisurata on 02/09/24.
//

import SwiftUI

struct ByteSelectionView: View {
    
    @Binding var byteList: [Byte]
    @Binding var selectedIdx: Int
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    Spacer()
                    ForEach(Array(byteList.enumerated()), id:\.element.id) { idx, byte in
                        
                        if isSelected(idx) {
                            ByteCardView(
                                imageName: cardImage(idx),
                                isPrimary: byte.isPrimary,
                                isSelected: isSelected(idx),
                                isTrial: byte.byteData.isTrial
                            )
                            .frame(width: cardWidth(idx))
                            .onTapGesture {
                                cardTapAction(idx)
                            }
                            .padding([.top, .bottom], 5)
                        } else {
                            ByteCardView(
                                imageName: cardImage(idx),
                                isPrimary: byte.isPrimary,
                                isSelected: isSelected(idx),
                                isTrial: byte.byteData.isTrial
                            )
                            .frame(width: cardWidth(idx))
                            .onTapGesture {
                                cardTapAction(idx)
                            }
                            .padding([.top, .bottom], 10)
                        }
                    }
                    Spacer()
                }
            }.frame(maxWidth: .infinity)
        }
        .background(.clear)
    }
    
    private func isSelected(_ idx: Int) -> Bool {
        return selectedIdx == idx
    }
    
    private func cardImage(_ idx: Int) -> String {
        let byte = byteList[idx]
        return byte.byteData.byteImage.pngUrl
    }
    
    private func cardWidth(_ idx: Int) -> CGFloat {
        if isSelected(idx) {
            return (UIScreen.main.bounds.width / 3) - 10
        }
        
        return (UIScreen.main.bounds.width / 3) - 25
    }
    
    private func cardTapAction(_ idx: Int) {
        selectedIdx = idx
    }
}

#Preview {
    @State var byteList: [Byte] = []
    
    @State var selectedIdx = 0
    
    return VStack {
        ByteSelectionView(byteList: $byteList, selectedIdx: $selectedIdx)
    }.background(.green)
}
