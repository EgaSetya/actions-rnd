//
//  ChatViewModel.swift
//  Bythen
//
//  Created by Darindra R on 30/09/24.
//

import Combine
import SwiftUI

class ChatViewModel: BaseViewModel {
    static func new(byteBuild: ByteBuild) -> ChatViewModel {
        return ChatViewModel(
            byteBuild: byteBuild,
            chatService: ChatService(),
            roomService: RoomService(),
            uploadService: UploadFileService(),
            unityApi: UnityApi.shared
        )
    }

    @Published var isByteOn: Bool = true
    @Published var shouldOpenAttachment: Bool = false
    @Published var shouldOpenImagePicker: Bool = false
    @Published var shouldOpenDocumentPicker: Bool = false
    @Published var shouldShowMemoryAlert: Bool = false

    @Published var byteBuild: ByteBuild
    @Published var viewState: ChatView.ViewState = .loading
    @Published var chatHistory: [ChatHistory] = []
    @Published var isGeneratingResponse: Bool = false {
        didSet {
            textFieldVM.isGeneratingResponse = isGeneratingResponse
        }
    }

    let didTapVoiceMode = PassthroughSubject<Void, Never>()
    var didNewRoomCreated: (Int64) -> Void = { _ in }

    private var roomID: Int64
    private var chatService: ChatServiceProtocol
    private var roomService: RoomServiceProtocol
    private var uploadService: UploadFileServiceProtocol
    private var unityApi: UnityApiProtocol
    private var cancellables = Set<AnyCancellable>()

    private let initialResponse = ChatHistory(
        id: 0,
        content: "",
        role: .initial
    )

    let textFieldVM = ChatTextFieldViewModel()

    init(
        byteBuild: ByteBuild,
        chatService: ChatServiceProtocol,
        roomService: RoomServiceProtocol,
        uploadService: UploadFileServiceProtocol,
        unityApi: UnityApiProtocol
    ) {
        self.byteBuild = byteBuild
        roomID = byteBuild.roomID
        self.chatService = chatService
        self.roomService = roomService
        self.uploadService = uploadService
        self.unityApi = unityApi
    }

    deinit {
        cancellables.removeAll()
    }

    @MainActor
    func bindTextFieldVM() async {
        textFieldVM.didTapSendMessage
            .sink { [weak self] chat in
                Task {
                    guard let self else { return }
                    guard !self.isGeneratingResponse else { return }
                    await self.didSendMessage(chat)
                }
            }
            .store(in: &cancellables)
    }

    func didShowError(_ message: String) {
        mainState?.showError(errMsg: message)
    }

    func didPickAttachment(_ attachment: Attachment) {
        textFieldVM.attachment = attachment
    }

    func didSelectTemplate(_ message: String) {
        textFieldVM.text = message
    }

    func didDissapear() {
        viewState = .loading
    }

    func changeByteBuild(byteBuild: ByteBuild) {
        viewState = .loading
        roomID = byteBuild.roomID
        self.byteBuild = byteBuild
    }

    func changeRoom(roomID: Int64) {
        Task { @MainActor in
            self.roomID = roomID
            await getChatHistory()
        }
    }

    @MainActor
    func getChatHistory() async {
        if roomID == 0 {
            viewState = .empty

            DispatchQueue.main.async {
                self.chatHistory = []
            }
            return
        }

        defer {
            self.setLoading(isLoading: false)
        }

        do {
            viewState = .loading
            setLoading(isLoading: true)

            let response = try await chatService.chatBytesHistory(buildID: byteBuild.buildID, roomID: roomID)
            if response.messages.isEmpty {
                viewState = .empty
            } else {
                chatHistory = response.messages
                viewState = .history
            }
        } catch {
            viewState = .empty
            Logger.logInfo("Error: \(error)")
            mainState?.showError(errMsg: "Unable to connect to chat service. Please try again later.")
        }
    }

    @MainActor
    func didSendMessage(_ chat: ChatHistory) async {
        do {
            /// Before we process new animation we need to make sure previous animation stop first
            unityApi.stopGenerate()
            unityApi.startAvatarAnimation()

            viewState = .history
            isGeneratingResponse = true
            var isNeedChatSummarize = false
            var attachmentURL: String?

            if let attachment = chat.attachment {
                attachmentURL = try await uploadAttachment(attachment)
            }

            if roomID == 0 {
                let roomID = try await roomService.createRooms(buildID: byteBuild.buildID, title: "New Room")
                self.roomID = roomID
                isNeedChatSummarize = true
                didNewRoomCreated(roomID)
            }

            chatHistory.append(chat)
            chatHistory.append(initialResponse)

            let stream = chatService.chatBytes(
                buildID: byteBuild.buildID,
                roomID: roomID,
                message: chat.content,
                fileURL: attachmentURL
            )

            await processMessage(stream)
            isGeneratingResponse = false
            unityApi.endChatResponse()

            if isNeedChatSummarize {
                _ = try await chatService.chatBytesSummary(buildID: byteBuild.buildID, roomID: roomID)
            }
        } catch {
            Logger.logInfo("Error: \(error)")
            mainState?.showError(errMsg: "Unable to connect to chat service. Please try again later.")
            isGeneratingResponse = false
            unityApi.stopGenerate()
        }
    }

    @MainActor
    func didRegenerateChat() async {
        /// Before we process new animation we need to make sure previous animation stop first
        unityApi.stopGenerate()
        unityApi.startAvatarAnimation()

        isGeneratingResponse = true
        chatHistory[chatHistory.count - 1] = initialResponse

        let stream = chatService.chatBytesRegenerate(
            buildID: byteBuild.buildID,
            roomID: roomID
        )

        await processMessage(stream)
        isGeneratingResponse = false
        unityApi.endChatResponse()
    }

    @MainActor
    func didTapThumbsdown() async {
        do {
            let chat = chatHistory[chatHistory.count - 1]
            let response = try await chatService.chatBytesThumbsDown(
                buildID: byteBuild.buildID,
                roomID: roomID,
                chatID: chat.id
            )

            chatHistory[chatHistory.count - 1].isBad = response.isFeedbackBad
        } catch {
            Logger.logInfo("Error: \(error)")
            mainState?.showError(errMsg: "Unable to connect to chat service. Please try again later.")
        }
    }

    @MainActor
    private func uploadAttachment(_ attachment: Attachment) async throws -> String {
        let response = try await uploadService.uploadFile(buildID: byteBuild.buildID, fileURL: attachment.fileURL)
        return response.fileURL
    }

    @MainActor
    private func processMessage(_ stream: AsyncStream<[ChatResponse]>) async {
        for await response in stream {
            for chat in response {
                let lastIndex = chatHistory.count - 1

                if chat.processing.isNotEmpty {
                    chatHistory[lastIndex].role = .assistant
                    chatHistory[lastIndex].isProcessing = chat.processing == "search"
                    chatHistory[lastIndex].isMemoryAdded = chat.processing == "memory"
                }

                if let searchData = chat.dataURL {
                    chatHistory[lastIndex].searchData.append(searchData)
                }

                let combinedContent = chat.getCombineContent()
                if combinedContent.isNotEmpty {
                    chatHistory[lastIndex].role = .assistant
                    chatHistory[lastIndex].isProcessing = false
                    chatHistory[lastIndex].content.append(combinedContent)
                }

                if isByteOn, chat.voice.isNotEmpty {
                    unityApi.setTalkingSpeed(value: 1.0)
                    unityApi.triggerAvatarVoice(
                        chat.voice,
                        emotion: chat.emotion,
                        voiceID: byteBuild.voiceModel,
                        voicePitch: byteBuild.voicePitch
                    )
                }

                if chat.showMemoryLimit {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        shouldShowMemoryAlert.toggle()
                    }
                }

                chatHistory[lastIndex].id = chat.chatID
            }
        }
    }
}
