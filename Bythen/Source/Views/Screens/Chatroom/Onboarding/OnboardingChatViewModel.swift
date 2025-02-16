//
//  OnboardingChatViewModel.swift
//  Bythen
//
//  Created by edisurata on 10/09/24.
//

import Combine
import Foundation

class OnboardingChatViewModel: BaseViewModel {
    static func new(byteBuild: ByteBuild) -> OnboardingChatViewModel {
        return OnboardingChatViewModel(
            byteBuild: byteBuild,
            staticAssetsService: StaticAssetsService(),
            byteBuildService: ByteBuildService()
        )
    }
    
    var didFinishOnboarding: (ByteBuild) -> Void = { _ in }

    @Published var stickers: [Sticker] = []
    @Published var stickerAnimation: StickerAnimation = .init()
    @Published var byteImageUrl: String = ""
    @Published var byteName: String = ""
    @Published var byteAge: String = ""
    @Published var byteGender: ByteGender = .empty
    @Published var isSaveButtonValid: Bool = false
    @Published var isEnableFloatAnimation: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private var staticAssetsService: StaticAssetsService
    private var byteBuild: ByteBuild
    private var byteBuildService: ByteBuildServiceProtocol

    init(byteBuild: ByteBuild, staticAssetsService: StaticAssetsService, byteBuildService: ByteBuildServiceProtocol) {
        self.byteBuild = byteBuild
        self.staticAssetsService = staticAssetsService
        self.byteBuildService = byteBuildService
        self.byteImageUrl = byteBuild.byteData.byteImage.pngUrl
        super.init()
        setupObserver()
    }
    
    func bindActions(
        didFinishOnboarding: @escaping (ByteBuild) -> Void
    ) {
        self.didFinishOnboarding = didFinishOnboarding
    }

    func setupObserver() {
        $byteName
            .combineLatest($byteAge, $byteGender)
            .sink { [weak self] name, age, gender in
                guard let self = self else { return }

                let isNameValid = name.count > 0
                let isAgeValid = age.count > 0
                let isGenderValid = gender != .empty

                DispatchQueue.main.async {
                    self.isSaveButtonValid = isNameValid && isAgeValid && isGenderValid
                }

            }.store(in: &cancellables)
    }

    func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let resp: GetStickersResponse = try await self.staticAssetsService.getAssets(path: .stickers)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.isEnableFloatAnimation = resp.enabled
                    self.stickers = resp.stickers
                    self.stickerAnimation = resp.animation
                }
            } catch let err as HttpError {
                DispatchQueue.main.async {
                    self.handleError(err)
                }
            }
        }
    }

    func createBuild() {
        Task { [weak self] in
            guard let self = self else { return }

            guard let ageValue = Int64(self.byteAge) else {
                DispatchQueue.main.async {
                    self.handleError(AppError(code: 0, message: "Age Invalid"))
                }
                return
            }

            let params = CreateBuildParams(
                byteID: self.byteBuild.byteData.byteID,
                byteSymbol: self.byteBuild.byteData.byteSymbol,
                mode: "onboard",
                byteName: self.byteName,
                age: ageValue,
                gender: self.byteGender.rawValue
            )

            DispatchQueue.main.async {
                self.setLoading(isLoading: true)
            }

            do {
                try await self.byteBuildService.createBuild(params: params)
                DispatchQueue.main.async {
                    self.setLoading(isLoading: false)
                    self.didFinishOnboarding(self.byteBuild)
                }
            } catch let err as HttpError {
                DispatchQueue.main.async {
                    self.handleError(err)
                }
            }
        }
    }
}
