//
//  ChatBubble.swift
//  Bythen
//
//  Created by Darindra R on 07/10/24.
//

import MarkdownUI
import SwiftUI

struct ChatBubble: View {
    let index: Int

    @ObservedObject
    var viewModel: ChatViewModel

    @State
    private var isSearchExpanded: Bool = false

    @State
    private var shouldShowImageViewer: Bool = false

    private var chat: ChatHistory {
        if viewModel.chatHistory.count > index {
            return viewModel.chatHistory[index]
        }
        return ChatHistory(id: 0, content: "", role: .assistant)
    }

    private var shouldEnableFooter: Bool {
        let isLastMessage = viewModel.chatHistory.count == index + 1
        return isLastMessage && !viewModel.isGeneratingResponse
    }

    var body: some View {
        switch chat.role {
        case .initial:
            HStack {
                ThreeDotsLoader()
                Spacer()
            }
            .frame(height: 36)
            .padding(.leading, 8)

        case .assistant:
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    if chat.isProcessing {
                        ChatSearchShimmerView()
                    } else {
                        if chat.isMemoryAdded {
                            HStack(spacing: 6) {
                                Image("task.fill")
                                    .renderingMode(.template)
                                    .foregroundColor(.appBlack.opacity(0.5))
                                    .font(.system(size: 14))

                                Text("Memory Added")
                                    .font(FontStyle.dmMono(.medium, size: 14))
                                    .foregroundStyle(.appBlack.opacity(0.5))
                            }
                        }

                        if !chat.searchData.isEmpty {
                            HStack(spacing: 4) {
                                Text("Searched \(chat.searchData.count) sites")
                                    .font(FontStyle.dmMono(.medium, size: 14))
                                    .foregroundStyle(.appBlack.opacity(0.5))

                                Image("chevron-down-white")
                                    .resizable()
                                    .renderingMode(.template)
                                    .rotationEffect(.degrees(isSearchExpanded ? 0 : 180))
                                    .foregroundStyle(.appBlack.opacity(0.5))
                                    .frame(width: 16, height: 16)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.prepare()
                                generator.impactOccurred()

                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isSearchExpanded = !isSearchExpanded
                                }
                            }
                        }

                        if isSearchExpanded {
                            ChatSearchView(data: chat.searchData)
                        }

                        Markdown(chat.content)
                            .markdownTextStyle {
                                FontFamily(.custom("NeueMontreal-Regular"))
                                FontSize(16)
                            }
                            .textSelection(.enabled)

                        if shouldEnableFooter {
                            footer
                        }
                    }
                }

                Spacer()
            }

        case .user:
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 12) {
                    if let fileURL = chat.fileURL {
                        AsyncImage(url: URL(string: fileURL)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 163, height: 163)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .onTapGesture {
                                        shouldShowImageViewer = true
                                    }
                                    .fullScreenCover(isPresented: $shouldShowImageViewer) {
                                        ImageViewer(image: image)
                                    }
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundStyle(Color(hex: "#C5D6F8"))
                                    .frame(width: 163, height: 163)
                                    .overlay(alignment: .center) {
                                        ProgressView()
                                    }
                            }
                        }

                    } else if let attachment = chat.attachment, case let .image(image) = attachment.type {
                        Image(uiImage: image!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 163, height: 163)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                shouldShowImageViewer = true
                            }
                            .fullScreenCover(isPresented: $shouldShowImageViewer) {
                                ImageViewer(image: Image(uiImage: image!))
                            }
                    }

                    if chat.content.isNotEmpty {
                        Text(chat.content)
                            .textSelection(.enabled)
                            .font(FontStyle.neueMontreal(.regular, size: 16))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color(hex: "#C5D6F8"))
                            .clipShape(
                                RoundedCornersShape(
                                    corners: [.topLeft, .bottomLeft, .topRight],
                                    radius: 24
                                )
                            )
                    }
                }
            }
        }
    }

    var footer: some View {
        HStack(spacing: 4) {
            Button {
                UIPasteboard.general.string = chat.content
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                generator.impactOccurred()
            } label: {
                Image(AppImages.kDocIcon)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(.all, 4)
            }

            Button {
                Task {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.prepare()
                    generator.impactOccurred()
                    await viewModel.didRegenerateChat()
                }
            } label: {
                Image(AppImages.kRegenerateIco)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(.all, 4)
            }

            Button {
                Task {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.prepare()
                    generator.impactOccurred()
                    await viewModel.didTapThumbsdown()
                }
            } label: {
                Image(systemName: chat.isBad ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(chat.isBad ? Color(hex: "#f04406") : Color(hex: "#0E100F").opacity(0.5))
                    .frame(width: 16, height: 16)
                    .padding(.all, 4)
            }
            .isHidden(chat.id == 0, remove: true)
        }
    }
}
