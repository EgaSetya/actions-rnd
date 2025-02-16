//
//  MemoriesCell.swift
//  Bythen
//
//  Created by erlina ng on 06/10/24.
//
import SwiftUI

struct MemoriesCell: View {
    @State var isSelected: Bool
    @Binding var isShowCheckBox: Bool
    @State var isShowBottomSheet: Bool = false
    var memory: Memory
    var onTap: (Bool) -> Void
    var onDismissBottomSheet: () -> Void
    
    var body: some View {
        HStack {
            HStack {
                Text(memory.name)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
            }
            checkbox.isHidden(!$isShowCheckBox.wrappedValue)
                .onTapGesture {
                    if isShowCheckBox {
                        isSelected.toggle()
                        onTap(isSelected)
                    }
                }
        }
        .padding(16)
        .border(Color.appBlack, width: 1)
        .onTapGesture {
            isShowBottomSheet = true
        }
        .sheet(isPresented: $isShowBottomSheet, onDismiss: {
            onDismissBottomSheet()
        }) {
            MemoriesBottomSheet(viewModel: MemoriesBottomSheetViewModel(memory: memory))
        }
    }
    
    var checkbox: some View {
        ZStack {
            Rectangle()
                .stroke(Color.black, lineWidth: 1)
                .foregroundStyle(.appBlack)
                .frame(width: 24, height: 24)
                
            if isSelected {
                Image("check")
                    .renderingMode(.template)
                    .foregroundStyle(.byteBlack)
            }
        }
        .background(isSelected ? Color.gokuOrange : Color.clear)
    }
}
