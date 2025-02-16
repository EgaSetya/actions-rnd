//
//  RoomItemView.swift
//  Bythen
//
//  Created by edisurata on 18/09/24.
//

import SwiftUI

struct HighlightedText: View {
    var text: String
    var keyword: String
    var highlightColor: Color = .sonicBlue700

    var body: some View {
        let parts = text.lowercased().components(separatedBy: keyword.lowercased())

        return parts.enumerated().reduce(Text("")) { result, part in
            parts.enumerated().reduce(Text("")) { result, part -> Text in
                let (index, substring) = part

                return result + Text(substring) + (index < parts.count - 1 ? Text(keyword).foregroundColor(.sonicBlue700) : Text(""))
            }
        }
    }
}

struct RoomItemView: View {
    @StateObject var viewModel: RoomItemViewModel

    @State private var selectedBgColor: Color = .appBlack.opacity(0.05)

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                if viewModel.isPrimary {
                    Image("star")
                        .resizable()
                        .frame(width: 14, height: 13)
                        .foregroundStyle(.sonicBlue700)
                        .padding(.horizontal, 4)
                    Text("Primary Room")
                        .foregroundStyle(.appBlack)
                        .font(FontStyle.neueMontreal(.medium, size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    if viewModel.highlightedText != nil {
                        HighlightedText(text: viewModel.title, keyword: viewModel.highlightedText!)
                            .foregroundStyle(.appBlack)
                            .font(FontStyle.neueMontreal(.medium, size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                    } else {
                        Text(viewModel.title)
                            .foregroundStyle(.appBlack)
                            .font(FontStyle.neueMontreal(.medium, size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                    }
                }
            }
            .padding(.horizontal, 12)
            if !viewModel.isPrimary {
                Text(viewModel.description)
                    .foregroundStyle(.appBlack.opacity(0.7))
                    .font(FontStyle.neueMontreal(size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .padding(.horizontal, 12)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(viewModel.isSelected ? .appBlack.opacity(0.05) : .white)
                .frame(maxWidth: .infinity, maxHeight: 60)
                .padding(.horizontal, 12)
        )
        .onTapGesture(perform: {
            withAnimation {
                viewModel.selectRoomAction()
            }
        })
        .if(!viewModel.isPrimary, transform: { view in
            view.contextMenu(ContextMenu(menuItems: {
                RoomsItemContextMenu(
                    renameAction: viewModel.renameRoomAction,
                    deleteAction: viewModel.deleteRoomAction
                )
            }))
        })
    }
}

#Preview {
    VStack {
        RoomItemView(viewModel: RoomItemViewModel(room: Room(title: "hello"), index: 0))
    }.background(.white)
}
