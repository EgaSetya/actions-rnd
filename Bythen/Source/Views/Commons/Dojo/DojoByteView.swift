//
//  DojoByteView.swift
//  Bythen
//
//  Created by edisurata on 11/10/24.
//

import SwiftUI

struct DojoByteView<Destination>: View where Destination: View {
    @Environment(\.colorScheme) var theme
    @Binding var byteImageUrl: String
    @Binding var byteName: String
    @Binding var byteInfo: String
    @Binding var disableEdit: Bool
    var navigateUpdateByte: Destination
    
    var body: some View {
        HStack {
            CachedAsyncImage(urlString: byteImageUrl)
                .frame(maxWidth: 56, maxHeight: 56)
                .background(ByteColors.foreground(for: theme))
                .clipShape(Circle())
                .padding(.vertical, 16)
                .padding(.leading, 16)
            VStack {
                Text(byteName)
                    .font(FontStyle.foundersGrotesk(.semibold, size: 32))
                    .foregroundStyle(ByteColors.foreground(for: theme))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(byteInfo)
                    .font(FontStyle.neueMontreal(size: 12))
                    .foregroundStyle(ByteColors.foreground(for: theme).opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            if !disableEdit {
                NavigationLink(destination: navigateUpdateByte) {
                    Image("pen.sharp.solid")
                        .resizable()
                        .foregroundStyle(ByteColors.foreground(for: theme))
                        .frame(width: 16, height: 16)
                        .padding(10)
                        .background(ByteColors.background(for: theme).opacity(0.05))
                        .clipShape(Circle())
                }
                .padding(6)
                .padding(.trailing, 12)
            }
        }
        .padding(.horizontal, 3)
        .background(ByteColors.background(for: theme))
    }
}

#Preview {
    VStack {
        DojoByteView(
            byteImageUrl: .constant("https://assets.bythen.ai/bythen-pod/pod-azuki.webp"),
            byteName: .constant("MARCOPOLO"),
            byteInfo: .constant("Male / 22y / Personal Assitant"),
            disableEdit: .constant(true),
            navigateUpdateByte: UpdateByteView(viewModel: UpdateByteViewModel.new())
        )
    }
}
