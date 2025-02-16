//
//  ByteItemView.swift
//  Bythen
//
//  Created by edisurata on 18/09/24.
//

import SwiftUI

struct ByteItemView: View {
    @StateObject var viewModel: ByteItemViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(viewModel.isSelected ? .appBlack.opacity(0.05) : .white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity, maxHeight: 60)
                .padding(.horizontal, 8)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1)) {
                        viewModel.selectByte()
                    }
                }
            HStack {
                CircularImageView(urlString: viewModel.imageUrl)
                    .frame(maxWidth: 32, maxHeight: 32)
                    .padding(.vertical, 14)
                    .padding(.leading, 12)
                VStack {
                    if viewModel.highlightedText != nil {
                        HighlightedText(text: viewModel.name, keyword: viewModel.highlightedText!)
                            .font(FontStyle.foundersGrotesk(.semibold, size: 16))
                            .foregroundStyle(.appBlack)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text(viewModel.name)
                            .font(FontStyle.foundersGrotesk(.semibold, size: 16))
                            .foregroundStyle(.appBlack)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if viewModel.highlightedText != nil {
                        HighlightedText(text:viewModel.roles, keyword: viewModel.highlightedText!)
                            .font(FontStyle.neueMontreal(.regular, size: 12))
                            .foregroundStyle(.appBlack.opacity(0.7))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text(viewModel.roles)
                            .font(FontStyle.neueMontreal(.regular, size: 12))
                            .foregroundStyle(.appBlack.opacity(0.7))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                if viewModel.isPrimary {
                    ZStack {
                        Rectangle()
                            .fill(.sonicBlue300)
                            .frame(maxWidth: viewModel.isSelected ? 80 : 28, maxHeight: 20)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        HStack {
                            Image("star")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(.appBlack)
                                .frame(width: 12, height: 12)
                            if viewModel.isSelected {
                                Text("PRIMARY")
                                    .font(FontStyle.dmMono(.regular, size: 11))
                                    .foregroundStyle(.appBlack)
                            }
                        }
                    }
                    .padding(.trailing, 12)
                }
            }
            .padding(.horizontal, 8)
        }
        .contextMenu(ContextMenu(menuItems: {
            BytesItemContextMenu(setPrimaryAction: viewModel.setAsPrimary)
        }))
        
    }
}

#Preview {
    @State var isSelected = false
    
    return VStack {
        ByteItemView(viewModel: ByteItemViewModel(byte: Byte(), index: 0, didSelectByte: { _ in }, didSetAsPrimary: { _ in }))
    }
    .background(.white)
}
