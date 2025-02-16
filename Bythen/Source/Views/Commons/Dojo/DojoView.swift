//
//  DojoView.swift
//  Bythen
//
//  Created by edisurata on 30/09/24.
//

import SwiftUI

struct DojoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var viewModel: DojoViewModel
    @State var isShowMiniByteView: Bool = false
    @State var isShowBottomSheet: Bool = false
    @State var isShowMemoriesPopupConfirmation: Bool = false
    @State private var onTapDeleteMemories: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section {
                        GeometryReader { geometry in
                            DojoByteView(
                                byteImageUrl: $viewModel.byteImageUrl,
                                byteName: $viewModel.byteName,
                                byteInfo: $viewModel.byteInfo,
                                disableEdit: $viewModel.disableEdit,
                                navigateUpdateByte: UpdateByteView(viewModel: viewModel.getUpdateByteViewModel())
                            )
                            .onChange(of: geometry.frame(in: .global).minY) { minY in
                                if minY < UIScreen.main.bounds.height && minY > 0 {
                                    // The view is visible
                                    isShowMiniByteView = false
                                    
                                } else {
                                    isShowMiniByteView = true
                                }
                            }
                        }
                        .frame(height: 88)
                    }
                    
                    Section {
                        switch viewModel.selectedTab {
                        case .background:
                            PersonalityView(viewModel: viewModel.personalityVM)
                        case .dialogue:
                            DialogueView(viewModel: viewModel.dialogueVM)
                        case .voice:
                            ChangeVoiceView(viewModel: viewModel.changeVoiceVM)
                        case .memories:
                            MemoriesView(
                                viewModel: viewModel.getMemoriesViewModel(),
                                showDeletePopUp: { bool, count, onTapDeleteMemories in
                                    self.viewModel.memoriesCount = count
                                    self.isShowMemoriesPopupConfirmation = bool
                                    self.onTapDeleteMemories = onTapDeleteMemories
                                }
                            )
                        case .settings:
                            SettingsView(
                                onTapSetting: { isShowBottomSheet in
                                    self.isShowBottomSheet = isShowBottomSheet
                                }
                            )
                        }
                    } header: {
                        DojoTabHeader(selectedTab: $viewModel.selectedTab, isStudioMode: $viewModel.isStudioMode)
                    }
                    
                }
            }
            
            if isShowMemoriesPopupConfirmation {
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
            }
            
            if isShowBottomSheet {
                ByteBottomSheet(onDismiss: { isShowBottomSheet in
                    withAnimation(.easeInOut) {
                        self.isShowBottomSheet = isShowBottomSheet
                    }
                }, content: {
                    SettingBottomSheetView(
                        viewModel: viewModel.getSettingBottomSheetViewModel(
                            onComplete: {
                                withAnimation(.easeInOut) {
                                    self.isShowBottomSheet = false
                                    dismiss()
                                }
                            }
                        ))
                        .background(ByteColors.background(for: colorScheme))
                        .padding(.bottom, 0)
                        .zIndex(1.0)
                }, backgroundColor: ByteColors.background(for: colorScheme), spacing: 8)
            }
            
            if isShowMemoriesPopupConfirmation {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button(action: { isShowMemoriesPopupConfirmation = false }) {
                            Image("close")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundStyle(.byteBlack)
                                .frame(width: 15, height: 15)
                                .padding(18.5)
                        }
                    }
                    
                    Text("Delete Memories?")
                        .font(FontStyle.foundersGrotesk(.medium, size: 28))
                        .padding(.bottom, 12)
                        .padding(.horizontal, 28)
                    Group {
                        Text("This action will permanently delete ")
                            .font(FontStyle.neueMontreal(.regular, size: 14))
                        + Text("\(viewModel.memoriesCount) memories ")
                            .font(FontStyle.neueMontreal(.medium, size: 14))
                        + Text("and cannot be undone.")
                            .font(FontStyle.neueMontreal(.regular, size: 14))
                    }
                    .font(FontStyle.neueMontreal(.regular, size: 14))
                    .lineSpacing(6)
                    .kerning(0.28)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 28)
                    .padding(.horizontal, 28)
                    
                    Button {
                        onTapDeleteMemories?()
                        isShowMemoriesPopupConfirmation = false
                        print("DELETED")
                    } label: {
                        Text("DELETE")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .font(FontStyle.foundersGrotesk(.semibold, size: 18))
                    }
                    .background(.elmoRed500)
                    .buttonStyle(.borderless)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 28)
                    .padding(.horizontal, 28)
                }
                .background(Color.white)
                .padding(.horizontal, 16)
                
            }
        }
        .trackView(page: "dojo", className: "DojoView")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(ByteColors.background(for: colorScheme))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("arrow-back")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(ByteColors.foreground(for: colorScheme))
                        .frame(width: 24, height: 24)
                        .padding(8)
                }
                
            }
            
            ToolbarItem(placement: .principal) {
                if isShowMiniByteView {
                    HStack(spacing: 0) {
                        CachedAsyncImage(urlString: viewModel.byteImageUrl)
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                            .background(Circle().stroke(ByteColors.foreground(for: colorScheme).opacity(0.05)))
                            .padding(8)
                        Text(viewModel.byteName)
                            .font(FontStyle.foundersGrotesk(.semibold, size: 16))
                            .foregroundStyle(ByteColors.foreground(for: colorScheme))
                    }
                    
                }
            }
        }
        .background(ByteColors.background(for: colorScheme))
    }
}

#Preview {
    DojoView(viewModel: DojoViewModel.new(byteBuild: ByteBuild()))
        .colorScheme(.dark)
}
