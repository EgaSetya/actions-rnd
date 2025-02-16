//
//  ByteInfoView.swift
//  Bythen
//
//  Created by edisurata on 02/09/24.
//

import SwiftUI

struct ByteInfoView: View {
    @Environment(\.colorScheme) var theme
    @EnvironmentObject var mainState: MainViewModel
    
    @State var initialDesc: String = ""
    @Binding var desc: String
    @State private var textViewHeight: CGFloat = 350 // Initial height
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                HStack {
                    Image(AppImages.kByteDescQuote)
                        .padding(.trailing, 5)
                        .foregroundStyle(ByteColors.foreground(for: theme))
                    VStack {
                        HStack {
                            Text("IN A NUTSHELL")
                                .font(FontStyle.dmMono(size: 11))
                                .foregroundStyle(ByteColors.foreground(for: theme))
                                .opacity(0.5)
                            Spacer()
                        }
                        
                        Rectangle()
                            .fill(ByteColors.foreground(for: theme).opacity(0.1))
                            .frame(height: 1)
                            .padding(.bottom, 10)
                    }
                }
                .padding([.leading, .trailing, .top])
                
                HStack(alignment: .bottom) {
                    Text(desc)
                        .font(FontStyle.foundersGrotesk(.semibold, size: 44))
                        .foregroundStyle(ByteColors.foreground(for: theme))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding(.horizontal, 10)
                
                Rectangle()
                    .fill(ByteColors.foreground(for: theme).opacity(0.1))
                    .frame(height: 1)
                    .padding([.leading, .trailing])
                    .padding(.top, 6)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(.clear)
            .onAppear(perform: {
            })
        }
    }
}

#Preview {
    return ByteInfoView(
        desc: .constant("I'M THE GUY\nWHO'S GONNA\nGET YOU HOME!\nARE YOU READY\nFOR SOME\nMISCHIEF?")
    )
    .background(.green)
    .environmentObject(MainViewModel.new())
}
