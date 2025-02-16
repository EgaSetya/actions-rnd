//
//  HiveSummaryBlockView.swift
//  Bythen
//
//  Created by erlina ng on 30/11/24.
//

import SwiftUI

struct HiveSummaryBlockView: View {
    @State var title: String = ""
    @State var tooltipMessage: String = ""
    @State var showToolTip: Bool = false
    @State var tooltipSide: TooltipSide = .bottom
    @Binding var amount: String
    @Binding var amountInDollar: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .bottom) {
                Text($title.wrappedValue)
                    .font(Font.dmMono(.medium, size: 11))
                    .foregroundStyle(Color.white.opacity(0.5))
                
                Spacer()
                
                Image(systemName: "info.circle")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.white.opacity(0.4))
                    .frame(height: 16)
                    .zIndex(200)
                    .tooltip(showToolTip, side: tooltipSide) {
                        Text(tooltipMessage)
                            .lineLimit(nil)
                            .font(Font.neueMontreal(.regular, size: 12))
                            .foregroundStyle(Color.white)
                            .multilineTextAlignment(.leading)
                    }
                    .onTapGesture {
                        showTooltip()
                    }
            }
            .zIndex(1)
            
            HStack(alignment: .bottom) {
                Text($amount.wrappedValue)
                    .font(Font.foundersGrotesk(.bold, size: 28))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                
                if $amountInDollar.wrappedValue.isNotEmpty {
                    Text("($\($amountInDollar.wrappedValue))")
                        .font(Font.dmMono(.medium, size: 14))
                        .foregroundStyle(Color.white.opacity(0.5))
                        .truncationMode(.tail)
                        .lineLimit(1)
                        .padding(5)
                }
            }
            .zIndex(0)
        }
        .padding(12)
        .background(Color.byteBlack)
    }
    
    internal func showTooltip() {
        DispatchQueue.main.async {
            showToolTip = true
        }
       
       DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
           showToolTip = false
       }
    }
}

