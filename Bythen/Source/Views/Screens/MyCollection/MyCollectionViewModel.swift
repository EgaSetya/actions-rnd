//
//  MyCollectionViewModel.swift
//  Bythen
//
//  Created by edisurata on 01/09/24.
//

import Foundation
import Combine

class MyCollectionViewModel: BaseViewModel {
    
    static func new() -> MyCollectionViewModel {
        return MyCollectionViewModel(
            byteService: ByteService(),
            unityNotification: UnityNotification.shared,
            unityApi: UnityApi.shared,
            byteBuildService: ByteBuildService(),
            appSession: AppSession.shared
        )
    }
    
    @Published var byteList: [Byte] = []
    @Published var selectedByteIdx = 0
    @Published var isByteActive = false
    @Published var byteName: String = ""
    @Published var byteInfoDesc: String = ""
    @Published var backgroundColorHex: String = "#0E100F"
    @Published var podCount: Int = 0
    @Published var avatarCount: Int = 0
    @Published var personalityDataPoints: [Double] = [0, 0, 0, 0, 0, 0]
    @Published var isOriginalNFTValid: Bool = false
    @Published var isBythePodValid: Bool = false
    @Published var isShowLoading = false
    @Published var summaryVM = ByteSummaryViewModel(profileInfo: "", role: "", xp: "", memories: "", knowledge: "", dataPoints: [], dataLabels: [])
    @Published var isDarkMode: Bool = false
    @Published var isPrimary: Bool = false
    @Published var isEnableEditGreetings: Bool = false
    @Published var isByteAssetNotReady: Bool = false
    @Published var isLoadingBytes: Bool = false
    @Published var isTrial: Bool = false
    @Published var showInvalidOriginalNFTBanner: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private var byteService: ByteServiceProtocol
    private var unityNotification: UnityNotificationProtocol
    private var unityApi: UnityApiProtocol
    private var byteBuildService: ByteBuildServiceProtocol
    private var appSession: AppSessionProtocol
    
    init(byteService: ByteService, unityNotification: UnityNotification, unityApi: UnityApi, byteBuildService: ByteBuildServiceProtocol, appSession: AppSessionProtocol) {
        self.byteService = byteService
        self.unityNotification = unityNotification
        self.unityApi = unityApi
        self.byteBuildService = byteBuildService
        self.appSession = appSession
        
        super.init()
        
        self.registerNotifications()
    }
    
    func registerNotifications() {
        if let avatarShowSignal = unityNotification.loadingScreenHiddenSignal {
            avatarShowSignal
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.isByteActive = true
                    self.isLoadingBytes = false
                    self.unityApi.changeProductType(productType: .collection)
                }.store(in: &cancellables)
        }
        
        $selectedByteIdx
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                if self.byteList.count <= 0 {
                    return
                }
                Logger.logInfo("triggered selection byte")
                self.updateDataForByteSelection()
            }
            .store(in: &cancellables)
    }
    
    func fetchByteList() {
        self.unityApi.prepareAvatar()
        Task {@MainActor [weak self] in
            guard let self else { return }
            self.isShowLoading = true
            self.isLoadingBytes = true
            do {
                let response = try await self.byteService.getBytes()
                self.byteList = response.bytes
                self.podCount = response.totalByte["pod"] ?? 0
                self.avatarCount = response.bytes.count
                self.updateDataForByteSelection()
                self.isShowLoading = false
            } catch let err {
                self.isShowLoading = false
                self.isLoadingBytes = false
                self.handleError(err)
            }
        }
    }
    
    func updateDescription() {
        if selectedByteIdx < byteList.count {
            var selectedByte = byteList[selectedByteIdx]
            selectedByte.greetings = byteInfoDesc
            byteList[selectedByteIdx] = selectedByte
            self.updateByteGreetings()
        }
    }
    
    func navigateToChatroom() -> (Int64, String) {
        let selectedByte = byteList[selectedByteIdx]
        return (selectedByte.byteData.byteID, selectedByte.byteData.byteSymbol)
    }
    
    func updateByteGreetings() {
        self.setLoading(isLoading: true)
        let selectedByte = byteList[selectedByteIdx]
        Task { @MainActor [weak self] in
            guard let self else { return }
            defer {
                self.setLoading(isLoading: false)
            }
            do {
                try await self.byteBuildService.updateGreetings(byteID: selectedByte.byteData.byteID, byteSymbol: selectedByte.byteData.byteSymbol, greetings: selectedByte.greetings)
            } catch let err {
                self.handleError(err)
            }
        }
    }
    
    private func getChartData(from byte: Byte) -> ([String], [Double]) {
        var points: [Double] = [0, 0, 0, 0, 0, 0]
        var labels: [String] = ["", "", "", "", "", ""]
        for (idx, perso) in byte.personalities.enumerated() {
            points[idx] = Double(perso.value.value) / 100
            labels[idx] = perso.value.name
        }
        return (labels, points)
    }
    
    private func updateDataForByteSelection() {
        if self.selectedByteIdx < self.byteList.count {
            self.isByteActive = false
            self.isLoadingBytes = true
            let selectedByte = self.byteList[self.selectedByteIdx]
            self.byteInfoDesc = String(selectedByte.greetings.prefix(60))
            self.backgroundColorHex = selectedByte.byteData.backgroundColor
            self.byteName = selectedByte.byteName.uppercased()
            self.summaryVM.profileInfo = "\(selectedByte.gender) / \(selectedByte.age)"
            self.summaryVM.role = selectedByte.role
            self.summaryVM.xp = "\(selectedByte.exp)"
            self.summaryVM.knowledge = "\(selectedByte.totalKnowledge)"
            self.summaryVM.memories = "\(selectedByte.totalMemory)"
            let (chartLabels, chartPoints) = self.getChartData(from: selectedByte)
            self.summaryVM.dataPoints = chartPoints
            self.summaryVM.dataLabels = chartLabels
            self.isOriginalNFTValid = selectedByte.byteData.isOriginalTokenValid
            self.isBythePodValid = selectedByte.byteData.isTrial ? false : true
            self.isTrial = selectedByte.byteData.isTrial
            if self.isTrial {
                self.globalCheckFreeTrial()
            }
            if selectedByte.byteData.colorMode == .dark {
                self.isDarkMode = false
                self.unityApi.changeTheme(theme: 1)
            } else {
                self.isDarkMode = true
                self.unityApi.changeTheme(theme: 0)
            }
            self.unityApi.setBackgroundColor(hexColorString: self.backgroundColorHex)
            self.isPrimary = selectedByte.isPrimary
            self.isEnableEditGreetings = selectedByte.buildID != 0
            self.isByteAssetNotReady = !selectedByte.byteData.isAssetReady
            self.unityApi.changeAvatarTraits(selectedByte.byteData.traits)
            if !selectedByte.byteData.isAssetReady {
                self.isLoadingBytes = false
            }
            self.showInvalidOriginalNFTBanner = !selectedByte.byteData.isOriginalTokenValid
        }
    }
}
