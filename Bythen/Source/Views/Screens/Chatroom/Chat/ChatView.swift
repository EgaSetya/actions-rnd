//
//  ChatRoomView.swift
//  Bythen
//
//  Created by Darindra R on 20/09/24.
//

import PhotosUI
import SwiftUI

struct ChatView: View {
    enum ViewState {
        case loading
        case empty
        case history
    }

    @EnvironmentObject
    var mainState: MainViewModel

    @StateObject
    var viewModel: ChatViewModel

    @State private var headerMaxY: CGFloat = .zero
    @State private var footerMinY: CGFloat = .zero
    @State private var byteOffset: CGSize = .zero

    @Binding var isShowRooms: Bool

    var header: some View {
        HStack {
            SideMenuButton().colorScheme(.light)
            Spacer()
            ByteToggleButton(isOn: $viewModel.isByteOn)
                .onChange(of: viewModel.isByteOn) { newValue in
                    AnalyticService.shared.trackClickEvent(button_name: "chat_byte_switch", value: newValue)
                }
        }
        .padding(.leading, 8)
        .padding(.vertical, 8)
        .padding(.trailing, 16)
        .overlay(alignment: .center) {
            Button(
                action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isShowRooms = true
                    }
                }
            ) {
                Text(viewModel.byteBuild.byteName.uppercased())
                    .font(FontStyle.foundersGrotesk(.semibold, size: 18))
                    .foregroundStyle(.appBlack)
                Image("chevron-down-white")
                    .resizable()
                    .renderingMode(.template)
                    .rotationEffect(.degrees(isShowRooms ? 0 : 180))
                    .foregroundStyle(.appBlack)
                    .frame(width: 16, height: 16)
            }
        }
        .overlay {
            GeometryReader { proxy in
                Color.clear
                    .onFirstAppear {
                        headerMaxY = proxy.frame(in: .named("chat_view")).maxY
                    }
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollViewReader { scrollProxy in
                ScrollView {
                    switch viewModel.viewState {
                    case .loading:
                        EmptyView()

                    case .empty:
                        ChatEmptyStateView(byte: viewModel.byteBuild) {
                            viewModel.didSelectTemplate($0)
                        }

                    case .history:
                        VStack(spacing: 24) {
                            LazyVStack(alignment: .leading, spacing: 24) {
                                ForEach(viewModel.chatHistory.indices, id: \.self) { index in
                                    ChatBubble(
                                        index: index,
                                        viewModel: viewModel
                                    )
                                    .id(index + 1)
                                }
                            }
                            .padding(.all, 16)

                            Color.clear
                                .frame(height: 1)
                                .id("bottom_scroll_view")
                        }
                        .onAppear {
                            scrollProxy.scrollTo("bottom_scroll_view", anchor: .bottom)
                        }
                        .onChange(of: viewModel.chatHistory) { _ in
                            withAnimation {
                                scrollProxy.scrollTo("bottom_scroll_view", anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .overlay(alignment: .top) {
                if viewModel.shouldShowMemoryAlert {
                    AlertActionView(
                        isPresented: $viewModel.shouldShowMemoryAlert,
                        isAutoClose: false,
                        title: "Maximum memory reached",
                        description: "Delete memories to free up space.",
                        actionTitle: "Edit Memory",
                        action: {
                            // TODO: Navigate to edit memory page
                        }
                    )
                }
            }

            footer
        }
        .coordinateSpace(name: "chat_view")
        .background(.appCream)
        .task {
            viewModel.setMainState(state: mainState)
            await viewModel.getChatHistory()
        }
        .onDisappear {
            viewModel.didDissapear()
        }
        .onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
        .overlay(alignment: .topLeading) {
            if headerMaxY != 0, footerMinY != 0 {
                ChatDraggableByteView(
                    maxTopBoundary: $headerMaxY,
                    maxBottomBoundary: $footerMinY,
                    offset: $byteOffset
                )
                .zIndex(1)
                .isHidden(!viewModel.isByteOn)
            }
        }
        .confirmationDialog(
            "Attach File",
            isPresented: $viewModel.shouldOpenAttachment,
            titleVisibility: .visible,
            actions: {
                Button("Files") {
                    viewModel.shouldOpenDocumentPicker = true
                }

                Button("Photos") {
                    viewModel.shouldOpenImagePicker = true
                }
            },
            message: {
                Text("Please select a source to attach your file.")
            }
        )
        .sheet(isPresented: $viewModel.shouldOpenDocumentPicker) {
            DocumentPicker(
                didFinishPicking: {
                    viewModel.didPickAttachment($0)
                },
                didFailedValidation: {
                    viewModel.didShowError("The file exceeds the 20MB size limit. Please select a smaller file.")
                }
            )
            .ignoresSafeArea(.all)
        }
        .sheet(isPresented: $viewModel.shouldOpenImagePicker) {
            ImagePicker(
                didFinishPicking: {
                    viewModel.didPickAttachment($0)
                },
                didFailedValidation: {
                    viewModel.didShowError("The file exceeds the 20MB size limit. Please select a smaller file.")
                }
            )
            .ignoresSafeArea(.all)
        }
    }

    var footer: some View {
        HStack(alignment: .bottom, spacing: 8) {
            BasicCircularButton(image: AppImages.kAttachmentIcon) {
                viewModel.shouldOpenImagePicker = true
            }

            ChatTextField(viewModel.textFieldVM)
                .task {
                    await viewModel.bindTextFieldVM()
                }

            Button(action: {
                viewModel.didTapVoiceMode.send()
                AnalyticService.shared.trackClickEvent(button_name: "voice_mode", value: nil)
            }, label: {
                Image("close")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 14, height: 14)
                    .foregroundStyle(.white)
                    .padding(17)
            })
            .background(Circle().fill(.sonicBlue700, strokeBorder: .byteBlack, lineWidth: 1))
        }
        .padding(.all, 16)
        .overlay {
            GeometryReader { proxy in
                Color.clear
                    .onFirstAppear {
                        byteOffset = CGSize(
                            width: UIScreen.main.bounds.width - 136,
                            height: proxy.frame(in: .named("chat_view")).minY - 160
                        )
                    }
                    .onChange(of: proxy.frame(in: .named("chat_view")).minY) { minY in
                        footerMinY = minY
                    }
            }
        }
    }
}
