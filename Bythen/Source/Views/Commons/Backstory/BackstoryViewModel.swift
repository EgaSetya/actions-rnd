//
//  BackstoryViewModel.swift
//  Bythen
//
//  Created by Darindra R on 22/10/24.
//

import Combine
import SwiftUI

class BackstoryViewModel: BaseViewModel {
    static func new(byteBuild: ByteBuild) -> BackstoryViewModel {
        return BackstoryViewModel(
            byteBuild: byteBuild,
            byteBuildService: ByteBuildService()
        )
    }

    @Published var description: String = ""
    @Published var isChatMode: Bool = false
    @Published var chat = [
        ChatHistory(
            id: 0,
            content: """
            Hi, im here to help you with your backstory. 

            First things first, would you like to start over or edit to the existing backstory?
            """,
            role: .assistant
        ),
    ]

    @Published var isFinished: Bool = false
    @Published var isDismissed: Bool = false
    @Published var isGeneratingResponse: Bool = false {
        didSet {
            textFieldVM.isGeneratingResponse = isGeneratingResponse
        }
    }

    let textFieldVM = ChatTextFieldViewModel()

    private let byteBuild: ByteBuild
    private let byteBuildService: ByteBuildServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    private let initialResponse = ChatHistory(
        id: 0,
        content: "",
        role: .initial
    )
    
    // MARK: Callbacks
    
    var savedBackstoryHandler: ((String) -> Void)?

    init(
        byteBuild: ByteBuild,
        byteBuildService: ByteBuildServiceProtocol
    ) {
        self.byteBuild = byteBuild
        self.byteBuildService = byteBuildService
        self.description = byteBuild.description
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

    @MainActor
    func didSendMessage(_ chat: ChatHistory) async {
        defer {
            isGeneratingResponse = false
        }

        do {
            isGeneratingResponse = true
            self.chat.append(chat)
            self.chat.append(initialResponse)

            let response = try await byteBuildService.generateDescription(
                buildID: byteBuild.buildID,
                params: getParams()
            )

            processChatResponse(response)
        } catch {
            Logger.logInfo("Error: \(error)")
            mainState?.showError(errMsg: "Unable to connect to chat service. Please try again later.")
        }
    }

    @MainActor
    func didSaveDescription(_ description: String) async {
        defer {
            setLoading(isLoading: false)
        }

        do {
            setLoading(isLoading: true)
            isDismissed = false ///Reset to default value
            
            try await byteBuildService.updateDescription(
                byteID: byteBuild.byteId,
                byteSymbol: byteBuild.byteSymbol,
                description: description
            )
            self.description = description
            if let successHandler = savedBackstoryHandler {
                successHandler(description)
            }
            isDismissed = true
        } catch {
            Logger.logInfo("Error: \(error)")
            mainState?.showError(errMsg: "Unable to connect to byte service. Please try again later.")
        }
    }

    @MainActor
    func didRegenerateChat() async {
        defer {
            isGeneratingResponse = false
        }

        do {
            isGeneratingResponse = true
            chat[chat.count - 1] = initialResponse

            let response = try await byteBuildService.generateDescription(
                buildID: byteBuild.buildID,
                params: getParams()
            )

            processChatResponse(response)
        } catch {
            Logger.logInfo("Error: \(error)")
            mainState?.showError(errMsg: "Unable to connect to chat service. Please try again later.")
        }
    }

    private func getParams() -> ByteDescriptionParams {
        var mutatedChat = chat
        mutatedChat.removeFirst()
        mutatedChat.removeAll(where: { $0.role == .initial })

        let message = mutatedChat.map { chat in
            ByteDescriptionChat(
                content: chat.remoteContent ?? chat.content,
                role: chat.role.rawValue
            )
        }

        return ByteDescriptionParams(messages: message)
    }

    private func processChatResponse(_ response: ByteDescriptionResponse) {
        isFinished = response.isFinished
        let lastIndex = chat.count - 1
        chat[lastIndex] = ChatHistory(
            id: 0,
            content: isFinished ? response.description : response.question,
            role: .assistant,
            remoteContent: response.content
        )
    }
}
