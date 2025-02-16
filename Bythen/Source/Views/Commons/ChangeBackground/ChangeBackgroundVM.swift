//
//  ChangeBackgroundVM.swift
//  Bythen
//
//  Created by edisurata on 29/09/24.
//

import Foundation

class ChangeBackgroundVM: BaseViewModel {
    
    static func new(byteID: Int64, byteSymbol: String, originSymbol: String, background: String, backgroundType: BackgroundType) -> ChangeBackgroundVM {
        return ChangeBackgroundVM(
            byteID: byteID,
            byteSymbol: byteSymbol,
            originSymbol: originSymbol,
            background: background,
            backgroundType: backgroundType,
            byteService: ByteService(),
            mediaBytesService: MediaBytesService(),
            unityApi: UnityApi.shared,
            byteBuildService: ByteBuildService()
        )
    }
    
    @Published var colors: [ByteBackgroundColor] = []
    @Published var backgrounds: [ByteBackground] = []
    @Published var bgImages: [ByteBackgroundImage] = []
    @Published var colorPresets: [ByteBackground] = []
    @Published var bgImagePresets: [ByteBackground] = []
    @Published var isSelectingImageForUpload: Bool = false
    @Published var selectedColor: String?
    @Published var selectedImageUrl: String?
    @Published var isShowDeleteDialog: Bool = false
    @Published var deletedBgImages: ByteBackgroundImage?
    
    private var byteService: ByteServiceProtocol
    private var mediaBytesService: MediaBytesServiceProtocol
    private var byteSymbol: String
    private var byteID: Int64
    private var unityApi: UnityApi
    private var changeColorTask: Task<Void, Error>?
    private var byteBuildService: ByteBuildServiceProtocol
    private var originSymbol: String
    
    init(
        byteID: Int64,
        byteSymbol: String,
        originSymbol: String,
        background: String,
        backgroundType: BackgroundType,
        byteService: ByteServiceProtocol,
        mediaBytesService: MediaBytesServiceProtocol,
        unityApi: UnityApi,
        byteBuildService: ByteBuildServiceProtocol
    ) {
        self.byteID = byteID
        self.byteSymbol = byteSymbol
        self.originSymbol = originSymbol
        self.byteService = byteService
        self.mediaBytesService = mediaBytesService
        self.unityApi = unityApi
        self.byteBuildService = byteBuildService
        if backgroundType == .color {
            self.selectedColor = background
        } else {
            self.selectedImageUrl = background
        }
    }
    
    func fetchData() {
        enum FetchResult {
            case colorLogs([ByteBackgroundColor])
            case backgrounds([ByteBackground])
            case images([ByteBackgroundImage])
        }

        Task { @MainActor [weak self] in
            guard let self = self else { return }
            
            do {
                // Collect results from each task
                let fetchResults = try await withThrowingTaskGroup(of: FetchResult.self) { group -> [FetchResult] in
                    // Add color logs fetching task
                    group.addTask {
                        do {
                            let resp = try await self.byteService.getBytesColorLogs()
                            return .colorLogs(resp.colorLogs)
                        } catch {
                            return .colorLogs([])
                        }
                    }

                    // Add backgrounds fetching task
                    group.addTask {
                        do {
                            let resp = try await self.mediaBytesService.getBytesBackgrounds(symbol: self.originSymbol)
                            return .backgrounds(resp.backgrounds)
                        } catch {
                            return .backgrounds([])
                        }
                    }

                    // Add background images fetching task
                    group.addTask {
                        do {
                            let resp = try await self.mediaBytesService.getBytesBackgroundImages()
                            return .images(resp.backgroundImages)
                        } catch {
                            return .images([])
                        }
                    }

                    // Accumulate all results in an array
                    var results: [FetchResult] = []
                    for try await result in group {
                        results.append(result)
                    }
                    return results // Return all the results once done
                }

                // Update the UI on the main thread
                for result in fetchResults {
                    switch result {
                    case .colorLogs(let logs):
                        self.colors = logs
                    case .backgrounds(let backgrounds):
                        self.backgrounds = backgrounds
                        self.colorPresets = backgrounds.filter{ $0.backgroundType == .color }
                        self.bgImagePresets = backgrounds.filter{ $0.backgroundType == .image }
                    case .images(let images):
                        self.bgImages = images
                    }
                }
                
            } catch {
                // Handle any errors on the main thread
                self.handleError(error)
            }
        }
    }
    
    func changeBgColor(color: String) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.unityApi.setBackgroundColor(hexColorString: color)
            self.selectedImageUrl = nil
            self.selectedColor = color
            await updateBytesBackground(background: color, type: .color)
            do {
                let resp = try await self.byteService.getBytesColorLogs()
                self.colors = resp.colorLogs
            } catch {
            }
        }
    }

    func delayedAction(after seconds: UInt64, action: @escaping () -> Void) {
        if let task = self.changeColorTask{
            task.cancel()
        }
        
        self.changeColorTask = Task {
            let nanoseconds = seconds * 1_000_000_000 // Convert seconds to nanoseconds
            try await Task.sleep(nanoseconds: nanoseconds)
            action() // Trigger the action after the delay
        }
    }
    
    func uploadBgImage(image: Attachment) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            defer {
                self.setLoading(isLoading: false)
            }
            
            self.setLoading(isLoading: true)
    
            do {
                let resp = try await self.mediaBytesService.uploadBackgroundImage(fileUrl: image.fileURL)
                self.changeBgImage(imageUrl: resp.fileUrl)
            } catch let err {
                self.handleError(err)
            }
        }
    }
    
    func changeBgImage(imageUrl: String) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.unityApi.setBackgroundImage(imageUrl: imageUrl)
            self.selectedColor = nil
            self.selectedImageUrl = imageUrl
            await updateBytesBackground(background: imageUrl, type: .image)
            do {
                let resp = try await self.mediaBytesService.getBytesBackgroundImages()
                self.bgImages = resp.backgroundImages
            } catch {
            }
        }
    }
    
    func updateBytesBackground(background: String, type: BackgroundType) async {
        do {
            try await self.byteBuildService.updateBackground(byteID: self.byteID, byteSymbol: self.byteSymbol, background: background, backgroundType: type)
        } catch let err {
            Logger.logError(err: err)
        }
    }
    
    func deleteBackgroundImage() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            guard let deletedBgImages = self.deletedBgImages else { return }
            if let imgUrl = self.selectedImageUrl, imgUrl == deletedBgImages.imageUrl {
                return
            }
            
            defer {
                self.setLoading(isLoading: false)
            }
            
            self.setLoading(isLoading: true)
            
            do {
                try await self.mediaBytesService.deleteBackgroundImage(fileUrl: deletedBgImages.imageUrl)
                let resp = try await self.mediaBytesService.getBytesBackgroundImages()
                self.bgImages = resp.backgroundImages
            } catch let error {
                self.handleError(error)
            }
        }
    }
}
