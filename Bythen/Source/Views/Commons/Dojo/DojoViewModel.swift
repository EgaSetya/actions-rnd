//
//  DojoViewModel.swift
//  Bythen
//
//  Created by edisurata on 30/09/24.
//

import Foundation
import Combine

enum DojoTab: Int, CaseIterable {
    case background
    case dialogue
    case voice
    case memories
    case settings
}

class DojoViewModel: BaseViewModel {
    static func new(byteBuild: ByteBuild, isStudioMode: Bool = false, selectedTab: DojoTab = .background) -> DojoViewModel {
        return DojoViewModel(byteBuild: byteBuild, isStudioMode: isStudioMode, selectedTab: selectedTab)
    }
    
    @Published var isPresenting: Bool = true
    @Published var selectedTab: DojoTab = .background
    @Published var byteName: String = ""
    @Published var byteImageUrl: String = ""
    @Published var byteInfo: String = ""
    @Published var isStudioMode: Bool = false
    @Published var disableEdit: Bool = false
    
    var memoriesCount: Int = 0 ///For memories pop-up purposes
    
    private var byteUpdatedSubject = PassthroughSubject<ByteBuild, Never>()
    var byteUpdateSignal: AnyPublisher<ByteBuild, Never> {
        get {
            return byteUpdatedSubject.eraseToAnyPublisher()
        }
    }
    private var byteBuildService: ByteBuildService = ByteBuildService()
    var byteBuild: ByteBuild
    private var cancellables = Set<AnyCancellable>()
    var dialogueVM: DialogueViewModel
    var changeVoiceVM: ChangeVoiceViewModel
    var personalityVM: PersonalityViewModel
    
    var didResetBuild: (() -> Void)?
    
    init(byteBuild: ByteBuild, isStudioMode: Bool = false, selectedTab: DojoTab = .background) {
        self.byteBuild = byteBuild
        self.dialogueVM = DialogueViewModel.new(byteBuild: byteBuild)
        self.changeVoiceVM = ChangeVoiceViewModel.new(byteBuild: byteBuild)
        self.personalityVM = PersonalityViewModel.new(byteBuild: byteBuild)
        self.isStudioMode = isStudioMode
        self.disableEdit = isStudioMode
        super.init()
        self.updateByte()
        self.setupChildViewModelsCallbacks()
        self.selectedTab = selectedTab
        if self.isStudioMode {
            self.selectedTab = .voice
        }
    }
    
    private func setupChildViewModelsCallbacks() {
        self.dialogueVM.setupCallbacks { [weak self] build in
            guard let self else { return }
            self.byteUpdatedSubject.send(build)
        }
        self.changeVoiceVM.setupCallbacks { [weak self] build in
            guard let self else { return }
            self.byteUpdatedSubject.send(build)
        }
    }
    
    func dismiss() {
        isPresenting = false
    }
    
    func updateByte() {
        self.byteName = byteBuild.byteName.uppercased()
        self.byteImageUrl = byteBuild.byteData.byteImage.thumbnailUrl
        self.byteInfo = "\(byteBuild.gender.rawValue) / \(byteBuild.age)y / \(byteBuild.role)"
    }
    
    func getUpdateByteViewModel() -> UpdateByteViewModel {
        let vm = UpdateByteViewModel.new(byteBuild: self.byteBuild)
        vm.successUpdateSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] build in
                guard let self else { return }
                
                self.byteBuild = build
                self.updateByte()
                self.byteUpdatedSubject.send(build)
            }
            .store(in: &cancellables)

        return vm
    }
    
    func getMemoriesViewModel() -> MemoriesViewModel {
        let vm = MemoriesViewModel.init(byteBuild: self.byteBuild)
        return vm
    }
    
    func getSettingBottomSheetViewModel(onComplete: @escaping () -> Void) -> SettingBottomSheetViewModel {
        return SettingBottomSheetViewModel(byteBuild: self.byteBuild, onComplete: {
            onComplete()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let handler = self.didResetBuild {
                    handler()
                }
            }
        })
    }
}
