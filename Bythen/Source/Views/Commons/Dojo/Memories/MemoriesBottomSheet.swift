//
//  MemoriesBottomSheet.swift
//  Bythen
//
//  Created by erlina ng on 8/10/24.
//
import SwiftUI

struct MemoriesBottomSheet: View {
    @StateObject var viewModel: MemoriesBottomSheetViewModel
    @Environment(\.dismiss) var dismiss
    private var textLength: Int {
        viewModel.memory.name.count
    }
    
    init(viewModel: MemoriesBottomSheetViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Image("close")
                    .resizable()
                    .frame(width: 13.5, height: 13.5)
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
            }
            
            HStack {
                Text("Memories")
                    .font(FontStyle.foundersGrotesk(.bold, size: 28))
                
                Spacer()
                
                Text("\(textLength)/150 Characters")
                    .font(FontStyle.neueMontreal(.regular, size: 16))
                    .foregroundStyle(Color.byteBlack500)
            }
            TextEditor(text: $viewModel.memory.name)
                .onChange(of: viewModel.memory.name, perform: { newValue in
                    if newValue.count > 150 {
                        self.viewModel.setMemoryNameLimit(newValue: newValue)
                   }
                })
            .frame(height: 168)
            .padding()
            
            BasicSquareButton(
                title: "Save Memory",
                action: {
                    viewModel.updateMemory()
                    dismiss()
                }
            )
            Spacer()
        }
        .padding([.horizontal, .top], 16)
    }
}
