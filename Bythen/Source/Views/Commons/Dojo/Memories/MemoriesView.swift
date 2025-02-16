//
//  MemoriesView.swift
//  Bythen
//
//  Created by erlina ng on 06/10/24.
//
import SwiftUI

struct MemoriesView: View {
    @State var searchMemories: String = ""
    @State var showDeletePopUp: (Bool, Int, (()->Void)?) -> Void
    @StateObject var viewModel: MemoriesViewModel
    
    init(viewModel: MemoriesViewModel, showDeletePopUp: @escaping (Bool, Int, (()->Void)?) -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.showDeletePopUp = showDeletePopUp
    }
    
    var body: some View {
        VStack {
            if viewModel.memories.count >= 100 {
                warningView
                .padding(.top, 24)
            }
            HStack {
                Text("Memory (\($viewModel.memories.count))")
                    .font(FontStyle.neueMontreal(.medium, size: 24))
                    .padding(.bottom, 12)
                    .padding(.top, 24)
                Spacer()
            }
            HStack(spacing: 8) {
                searchBar
                Button {
                    viewModel.isShowCheckBox.toggle()
                } label: {
                    HStack {
                        Text(viewModel.isShowCheckBox ? "CANCEL" : "SELECT")
                            .foregroundStyle(.black)
                            .font(FontStyle.foundersGrotesk(.semibold, size: 14))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.appBlack.opacity(0.1))
                    .buttonStyle(.borderless)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                }
                if viewModel.isShowCheckBox {
                    withAnimation {
                        Button {
                            showDeletePopUp(true, viewModel.selectedMemories.count) {
                                deleteMemories()
                            }
                        } label: {
                            HStack {
                                Text("DELETE")
                                    .foregroundStyle(.white)
                                    .font(FontStyle.foundersGrotesk(.semibold, size: 14))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(.elmoRed500)
                            .buttonStyle(.borderless)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                        }
                    }
                }
            }
            .padding(.bottom, 24)
            
            if viewModel.memories.count > 0 {
                memoriesList
            } else {
                emptyView
            }
            
            
        }
        .padding(.horizontal, 24)
        .onAppear {
            viewModel.fetchMemories()
        }
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)
                .frame(width: 12, height: 12)
            TextField("Search", text: $searchMemories)
                .font(FontStyle.neueMontreal(.regular, size: 12))
                .foregroundStyle(Color.byteBlack500)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 50))
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color.byteBlack500, lineWidth: 1)
        )
    }
    
    var warningView: some View {
        HStack {
            Image("info.fill")
                .resizable()
                .frame(width: 16.5, height: 16.5)
                .padding(.leading, 10)
                .foregroundStyle(Color.black)
            Group {
                Text("Maximum memory reached: ")
                    .font(FontStyle.neueMontreal(.medium, size: 14))
                + Text("Delete memories to free up space.")
                    .font(FontStyle.neueMontreal(.regular, size: 14))
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color.byteRedBackground)
    }
    
    var memoriesList: some View {
        VStack(spacing: -1) { ///Spacing is set to be -1 to make bottom border not double width
            ForEach(
                /// To Handle Search Filter
                $viewModel.memories.wrappedValue.filter { (memory) -> Bool in
                    memory.name.lowercased().contains(searchMemories.lowercased()) || searchForCountry(memory.name)
                },
                id: \.self
            ) { memory in
                MemoriesCell(
                    isSelected: false,
                    isShowCheckBox: $viewModel.isShowCheckBox,
                    memory: memory,
                    onTap: { isSelected in
                        if isSelected {
                            viewModel.selectedMemories.append(memory.id)
                        } else {
                            viewModel.selectedMemories.removeAll(where: { $0 == memory.id })
                        }
                    },
                    onDismissBottomSheet: {
                        viewModel.fetchMemories()
                    }
                )
            }
        }
    }
    
    var emptyView: some View {
        VStack(alignment: .center, spacing: 4) {
            Image(AppImages.kEmptyMemory)
            
            Text("It seems you don’t have any memories yet.")
                .font(FontStyle.neueMontreal(.medium, size: 16))
            
            Text("Chat more with your Byte to help them learn about you and start building memories from your interactions.")
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .font(FontStyle.neueMontreal(.medium, size: 16))
                .foregroundStyle(Color.byteBlack600)
        }
        
    }
    
    private func searchForCountry(_ txt: String) -> Bool {
        return (txt.lowercased(with: .current).hasPrefix(searchMemories.lowercased(with: .current)) || searchMemories.isEmpty)
    }
    
    internal func deleteMemories() {
        viewModel.deleteMemories()
        viewModel.isShowCheckBox.toggle()
    }
}

