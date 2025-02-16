//
//  RoomsSearchBar.swift
//  Bythen
//
//  Created by edisurata on 15/10/24.
//

import SwiftUI

struct RoomsSearchBar: View {
    
    @Binding var searchText: String
    var searchTextDidChange: (String) -> Void
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Image(AppImages.kSearchIco)
                    .resizable()
                    .frame(width: 14, height: 14)
                    .padding(.vertical, 11)
                    .padding(.leading, 12)
                TextField("Search", text: $searchText)
                    .font(FontStyle.neueMontreal(size: 14))
                    .background(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .onChange(of: searchText, perform: searchTextDidChange)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(.appBlack.opacity(0.4), lineWidth: 1)
            )
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Text("CANCEL")
                        .font(FontStyle.foundersGrotesk(.semibold, size: 16))
                        .foregroundStyle(.appBlack)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                }

            }
        }
    }
}

#Preview {
    @State var searchText: String = ""
    return VStack {
        RoomsSearchBar(searchText: $searchText) { _ in
            
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
}
