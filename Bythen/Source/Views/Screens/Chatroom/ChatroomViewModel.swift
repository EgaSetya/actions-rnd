//
//  ChatroomViewModel.swift
//  Bythen
//
//  Created by edisurata on 14/09/24.
//

import Combine
import Foundation
import SwiftUI

enum ChatroomPage {
    case avatar
    case chat
    case changeAvatar
    case onboarding
}

class ChatroomViewModel: BaseViewModel {
    static func new(byteID: Int64? = nil, byteSymbol: String? = nil) -> ChatroomViewModel {
        return ChatroomViewModel(
            byteService: ByteService(),
            byteBuildService: ByteBuildService(),
            byteID: byteID,
            byteSymbol: byteSymbol)
    }

    @Published var byteName: String = ""
    @Published var isShowRooms: Bool = false
    @Published var isByteLoaded: Bool = false
    @Published var page: ChatroomPage = .changeAvatar
    @Published var isShowLoading: Bool = false
    @Published var isNotInternetConnection: Bool = false
    var avatarViewModel: AvatarViewModel?
    var chatViewModel: ChatViewModel?
    @Published private var byteBuild = ByteBuild()

    private var roomsVM: RoomsViewModel?
    var onboardingVM: OnboardingChatViewModel?
    var byteID: Int64?
    var byteSymbol: String?
    private var byteService: ByteServiceProtocol
    private var byteBuildService: ByteBuildServiceProtocol
    private var onboarding: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init(
        byteService: ByteServiceProtocol,
        byteBuildService: ByteBuildServiceProtocol,
        byteID: Int64?,
        byteSymbol: String?
    ) {
        Logger.logInfo("Chat room init")
        self.byteService = byteService
        self.byteBuildService = byteBuildService
        self.byteID = byteID
        self.byteSymbol = byteSymbol
        super.init()
        observeByteBuild()
    }

    // MARK: - UI Updates
    
    func setParams(byteID: Int64, byteSymbol: String) {
        self.byteID = byteID
        self.byteSymbol = byteSymbol
    }
    
    private func observeByteBuild() {
        $byteBuild
            .receive(on: DispatchQueue.main)
            .sink { [weak self] byteBuild in
                guard let self else { return }
                if let avatarVM = self.avatarViewModel {
                    avatarVM.changeByte(byteBuild: byteBuild)
                }

                self.byteName = byteBuild.byteName
                self.chatViewModel = nil
            }
            .store(in: &cancellables)
    }

    func getAvatarViewModel() -> AvatarViewModel {
        if let vm = avatarViewModel {
            return vm
        }

        avatarViewModel = AvatarViewModel.new(
            byteBuild: byteBuild,
            tapChatModeAction: {
                self.page = .chat
            },
            onboarding: self.onboarding
        )
        
        self.onboarding = false

        avatarViewModel!.byteDidLoadedSignal
            .receive(on: DispatchQueue.main)
            .sink {
                self.isByteLoaded = true
            }
            .store(in: &cancellables)

        avatarViewModel!.byteBuildUpdatedSignal
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] build in
                guard let self else { return }
                self.byteBuild = build
                Task {
                    self.fetchByteBuild()
                }
            })
            .store(in: &cancellables)
        
        avatarViewModel!.reloadPageHandler = { [weak self] in
            guard let self else { return }
            self.fetchData()
        }
        
        avatarViewModel!.didNewRoomCreated = { [weak self] roomID in
            guard let self else { return }
            DispatchQueue.main.async {
                let roomsVM = self.getRoomsVM()
                roomsVM.selectedRoom = Room(roomID: roomID)
//                self.byteBuild.roomID = roomID
                if let vm = self.chatViewModel {
                    vm.changeRoom(roomID: roomID)
                }
            }
        }

        return avatarViewModel!
    }

    func fetchData() {
        isShowLoading = true
        page = .changeAvatar
        self.roomsVM = nil
        fetchByteBuild()
    }

    func getRoomsVM() -> RoomsViewModel {
        if let vm = roomsVM {
            return vm
        } else {
            roomsVM = RoomsViewModel.new(
                buildID: byteBuild.buildID,
                byteID: byteBuild.byteId,
                selectByteAction: self.handleSelectedByte(byte:),
                selectRoomAction: self.handleSelectedRoom(room:)
            )
            return roomsVM!
        }
    }

    func getOnboardingChatVM() -> OnboardingChatViewModel {
        let vm = OnboardingChatViewModel.new(byteBuild: byteBuild)
        vm.bindActions { byteBuild in
            self.byteID = byteBuild.byteData.byteID
            self.byteSymbol = byteBuild.byteData.byteSymbol
            self.onboarding = true
            self.avatarViewModel?.overlayViewState = .onboardingDojo
            self.fetchData()
        }
        return vm
    }

    func getChatViewModel() -> ChatViewModel {
        if let vm = chatViewModel {
            vm.isByteOn = true
            return vm
        }

        chatViewModel = ChatViewModel.new(byteBuild: byteBuild)
        return chatViewModel!
    }

    func changeAvatarLoadingComplete() {
        isShowLoading = false
    }

    private func fetchByteBuild() {
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            do {
                var build: ByteBuild
                if let byteID = self.byteID, let byteSymbol = self.byteSymbol {
                    build = try await byteBuildService.getBuild(byteID: byteID, byteSymbol: byteSymbol)
                } else {
                    build = try await byteBuildService.getBuildDefault()
                }
                await MainActor.run {
                    self.byteBuild = build
                    if self.byteBuild.buildID == 0 {
                        self.page = .onboarding
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.isByteLoaded = true
                        }
                    } else {
                        self.page = .avatar
                        let avatarVM = self.getAvatarViewModel()
                        avatarVM.changeByte(byteBuild: self.byteBuild)
                        let chatVM = self.getChatViewModel()
                        chatVM.changeByteBuild(byteBuild: self.byteBuild)
                    }
                }
            } catch let err {
                await MainActor.run {
                    if let err = err as? HttpError {
                        if err.code == .noInternetConnection {
                            self.isNotInternetConnection = true
                        } else if err.code == .notFound || err.code == .internalServerError {
                            self.mainState?.viewPage = .invalidBytes
                        }
                    }
                    self.handleError(err)
                }
            }
        }
    }

    @MainActor
    func bindChatVM() async {
        if let vm = chatViewModel {
            vm.didNewRoomCreated = { [weak self] roomID in
                guard let self else { return }
                let roomsVM = self.getRoomsVM()
                roomsVM.selectedRoom = Room(roomID: roomID)
                
                if let vm = self.avatarViewModel {
                    vm.changeRoom(roomID: roomID)
                }
            }
            
            for await _ in vm.didTapVoiceMode.values {
                withAnimation {
                    self.page = .avatar
                }
            }
        }
    }

    // MARK: - Rooms callbacks

    private func handleSelectedByte(byte: Byte) {
        byteName = byte.byteName
        byteID = byte.byteData.byteID
        byteSymbol = byte.byteData.byteSymbol
        isShowRooms = false
        self.isByteLoaded = false
        fetchData()
    }

    private func handleSelectedRoom(room: Room) {
        if let vm = avatarViewModel {
            vm.changeRoom(roomID: room.roomID)
        }

        if let vm = chatViewModel {
            vm.changeRoom(roomID: room.roomID)
        }

        isShowRooms = false
    }
}
