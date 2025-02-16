//
//  PersonalityViewModel.swift
//  Bythen
//
//  Created by erlina ng on 12/10/24.
//

import Foundation
import Combine

class PersonalityViewModel: BaseViewModel {
    private var staticAssetsService: StaticAssetsServiceProtocol = StaticAssetsService()
    @Published internal var byteBuild: ByteBuild
    private var byteBuildService: ByteBuildServiceProtocol = ByteBuildService()
    
    @Published var description: String
    
    /// Personality properties
    @Published var bytePersonalities: [BytePersonality] = []
    private var introvert: Int64 = 0
    private var agreeable: Int64 = 0
    private var lively: Int64 = 0
    private var spontaneous: Int64 = 0
    private var open: Int64 = 0
    private var apathy: Int64 = 0
    
    @Published var byteTraits: [String] = []
    var backstoryViewModel: BackstoryViewModel
    
    internal init(byteBuild: ByteBuild, staticAssetsService: StaticAssetsServiceProtocol, byteBuildService: ByteBuildServiceProtocol) {
        self.byteBuild = byteBuild
        self.staticAssetsService = staticAssetsService
        self.byteBuildService = byteBuildService
        self.byteTraits = byteBuild.traits.filter { $0 != "" }
        self.description = byteBuild.description.isNotEmpty ? byteBuild.description : "-"
        self.backstoryViewModel = BackstoryViewModel.new(byteBuild: byteBuild)
        super.init()
    }
    
    static func new(byteBuild: ByteBuild = ByteBuild()) -> PersonalityViewModel {
        return PersonalityViewModel(
            byteBuild: byteBuild,
            staticAssetsService: StaticAssetsService(),
            byteBuildService: ByteBuildService()
        )
    }
    
    internal func fetchBuild() {
        Task { [weak self] in
            guard let self else { return }
            defer {
                self.setLoading(isLoading: false)
            }
            self.setLoading(isLoading: true)
            do {
                let byteBuild = try await byteBuildService.getBuild(byteID: byteBuild.byteId, byteSymbol: byteBuild.byteSymbol)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.byteBuild = byteBuild
                    self.byteTraits = byteBuild.traits.filter { $0 != "" }
                    self.description = byteBuild.description.isNotEmpty ? byteBuild.description : "-"
                }
            } catch let err as HttpError {
                DispatchQueue.main.async {
                    self.handleError(err)
                }
            }
        }
    }
    
    internal func getBackstoryViewModel() -> BackstoryViewModel {
        self.backstoryViewModel = BackstoryViewModel.new(byteBuild: byteBuild)
        self.backstoryViewModel.savedBackstoryHandler = { [weak self] savedBackStory in
            guard let self else { return }
            
            self.byteBuild.description = savedBackStory
            
        }
        
        return self.backstoryViewModel
    }
    
    private func getNewestCurrentValue() {
        for i in 0 ..< bytePersonalities.count {
            if bytePersonalities[i].minLabel.lowercased() == "introvert" { introvert = bytePersonalities[i].currentValue }
            else if bytePersonalities[i].minLabel.lowercased() == "agreeable" { agreeable = bytePersonalities[i].currentValue }
            else if bytePersonalities[i].minLabel.lowercased() == "lively" { lively = bytePersonalities[i].currentValue }
            else if bytePersonalities[i].minLabel.lowercased() == "spontaneous" { spontaneous = bytePersonalities[i].currentValue }
            else if bytePersonalities[i].minLabel.lowercased() == "open" { open = bytePersonalities[i].currentValue }
            else if bytePersonalities[i].minLabel.lowercased() == "apathy" { apathy = bytePersonalities[i].currentValue }
        }
    }
    
    internal func updatePersonality() {
        getNewestCurrentValue()
        Task { [weak self] in
            guard let self else { return }
            defer {
                self.setLoading(isLoading: false)
            }
            self.setLoading(isLoading: true)
            do {
                try await self.byteBuildService.updatePersonality(
                    byteID: byteBuild.byteId,
                    byteSymbol: byteBuild.byteSymbol,
                    introvert: self.introvert,
                    open: self.open,
                    agreeable: self.agreeable,
                    apathy: self.apathy,
                    spontaneous: self.spontaneous,
                    lively: self.lively
                )
                self.fetchBuild()
            } catch let err as HttpError {
                DispatchQueue.main.async {
                    self.handleError(err)
                }
            }
        }
    }
    
    internal func addTraits(newValue: String, onCompletion:(() -> Void)?) {
        var traits = byteBuild.traits
        traits.append(newValue)
        updateTraits(traits: traits, onCompletion: onCompletion)
    }
    
    internal func deleteTrait(newValue: String, onCompletion:(() -> Void)?) {
        updateTraits(traits: byteBuild.traits.filter { $0 != newValue }, onCompletion: onCompletion)
    }
    
    private func updateTraits(traits: [String] = [], onCompletion:(() -> Void)?) {
        Task { [weak self] in
            guard let self else { return }
            defer {
                self.setLoading(isLoading: false)
            }
            
            self.setLoading(isLoading: true)
            do {
                try await self.byteBuildService.updateTraits(
                    byteID: byteBuild.byteId,
                    byteSymbol: byteBuild.byteSymbol,
                    traits: traits
                )
                self.fetchBuild()
                DispatchQueue.main.async {
                    onCompletion?()
                }
            } catch let err as HttpError {
                DispatchQueue.main.async {
                    self.handleError(err)
                    onCompletion?()
                }
            }
        }
    }
    
    internal func fetchPersonalities() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let resp: GetPersonalitiesResponse = try await self.staticAssetsService.getAssets(path: .personalities)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    var result = resp.bytePersonalities
                    for i in 0 ..< resp.bytePersonalities.count {
                        if result[i].minLabel.lowercased() == "introvert" { result[i].currentValue = byteBuild.introvert }
                        else if result[i].minLabel.lowercased() == "agreeable" { result[i].currentValue = byteBuild.agreeable }
                        else if result[i].minLabel.lowercased() == "lively" { result[i].currentValue = byteBuild.lively }
                        else if result[i].minLabel.lowercased() == "spontaneous" { result[i].currentValue = byteBuild.spontaneous }
                        else if result[i].minLabel.lowercased() == "open" { result[i].currentValue = byteBuild.open }
                        else if result[i].minLabel.lowercased() == "apathy" { result[i].currentValue = byteBuild.apathy }
                    }
                    self.bytePersonalities = result
                }
            } catch let err as HttpError {
                DispatchQueue.main.async {
                    self.handleError(err)
                }
            }
        }
    }
}
