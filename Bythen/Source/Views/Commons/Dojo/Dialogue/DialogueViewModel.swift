//
//  DialogueViewModel.swift
//  Bythen
//
//  Created by edisurata on 14/10/24.
//

import Foundation
import Combine

class DialogueViewModel: BaseViewModel {
    
    static func new(byteBuild: ByteBuild = ByteBuild()) -> DialogueViewModel {
        return DialogueViewModel(
            byteBuild: byteBuild,
            byteBuildService: ByteBuildService(),
            staticAssetsService: StaticAssetsService()
        )
    }
    
    enum DialogueStyle {
        case preset
        case custom
    }
    
    @Published var responseLength: Double = 0
    @Published var dialogueStyleText: String = ""
    @Published var customDialogueStyleText: String = ""
    @Published var dialogueStyle: DialogueStyle = .preset
    @Published var sampleDialoguePreview: String = ""
    var dialoguePresets: [DialogueStylePreset] = []
    
    private var byteBUildService: ByteBuildServiceProtocol
    private var staticAssetsService: StaticAssetsServiceProtocol
    
    private var byteBuild: ByteBuild
    private var cancellables = Set<AnyCancellable>()
    private var didUpdateByteBuild: (_ build: ByteBuild) -> Void = { _ in }
    
    init(byteBuild: ByteBuild, byteBuildService: ByteBuildServiceProtocol, staticAssetsService: StaticAssetsServiceProtocol) {
        self.byteBuild = byteBuild
        self.byteBUildService = byteBuildService
        self.staticAssetsService = staticAssetsService
        super.init()
        self.responseLength = Double(byteBuild.responseLength)
        if byteBuild.isCustomDialogue {
            self.dialogueStyle = .custom
            self.customDialogueStyleText = byteBuild.dialogueStyle
        } else {
            self.dialogueStyle = .preset
            self.dialogueStyleText = byteBuild.dialogueStyle
        }
        self.sampleDialoguePreview = byteBuild.sampleDialogue
    }
    
    func setupCallbacks(didUpdateByteBuild: @escaping (_ build: ByteBuild) -> Void) {
        self.didUpdateByteBuild = didUpdateByteBuild
    }
    
    func fetchData() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            do {
                let resp: [String: [DialogueStylePreset]] = try await self.staticAssetsService.getAssets(path: .dialogueStyles)
                self.dialoguePresets = resp["data"] ?? []
            } catch {
                self.handleError(error)
            }
        }
    }
    
    func tapDialoguePreset() {
        self.setDialogueStyle(.preset)
    }
    
    func tapDialogueCustom() {
        self.setDialogueStyle(.custom)
    }
    
    func setDialogueStyle(_ preset: DialogueStyle) {
        switch preset {
        case .preset:
            self.dialogueStyle = .preset
        case .custom:
            self.dialogueStyle = .custom
        }
    }
    
    func getDialogueStyle() -> (String, Bool) {
        switch self.dialogueStyle {
        case .preset:
            return (self.dialogueStyleText, false)
        case .custom:
            return (self.customDialogueStyleText, true)
        }
    }
    
    func updateDialogue() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            let (dialogueStyle, isCustom) = self.getDialogueStyle()
            self.didUpdateByteBuild(self.byteBuild)
            try await self.byteBUildService.updateDialogueStyle(
                byteID: self.byteBuild.byteId,
                byteSymbol: self.byteBuild.byteSymbol,
                responseLength: Int64(self.responseLength),
                dialogueStyle: dialogueStyle,
                isCustom: isCustom
            )
            
            self.byteBuild.responseLength = Int64(self.responseLength)
            self.byteBuild.dialogueStyle = dialogueStyle
            self.byteBuild.isCustomDialogue = isCustom
            
            let dialoguePreview: String = try await self.byteBUildService.updateDialoguePreview(
                buildID: self.byteBuild.buildID,
                responseLength: self.byteBuild.responseLength,
                dialogueStyle: dialogueStyle,
                isCustom: isCustom
            )
            
            self.byteBuild.sampleDialogue = dialoguePreview
            self.sampleDialoguePreview = dialoguePreview
            
            self.didUpdateByteBuild(self.byteBuild)
        }
    }
    
    func previewDialogue() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            defer {
                self.setLoading(isLoading: false)
            }
            
            self.setLoading(isLoading: true)
            let (dialogueStyle, isCustom) = self.getDialogueStyle()
            let dialoguePreview: String = try await self.byteBUildService.updateDialoguePreview(
                buildID: self.byteBuild.buildID,
                responseLength: Int64(self.responseLength),
                dialogueStyle: dialogueStyle,
                isCustom: isCustom
            )
            
            self.sampleDialoguePreview = dialoguePreview
        }
    }
}
