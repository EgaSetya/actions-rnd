//
//  HiveDashboardViewModel.swift
//  Bythen
//
//  Created by erlina ng on 08/12/24.
//

import Foundation
import SwiftUI

struct HiveOnboardingAssetViewModel: Equatable {
    var name: String?
    var videoURL: URL?
    var telegramGroupURL: URL?
    
    init() {}
    
    init(hiveOnboardingResponse: HiveOnboardingResponse, username: String?) {
        videoURL = URL(string: hiveOnboardingResponse.videoURL)
        telegramGroupURL = URL(string: hiveOnboardingResponse.telegramGroup)
        name = username
    }
}

class HiveDashboardViewModel: BaseViewModel {
    // MARK: - Properties
    @Published var username: String = ""
    @Published var profileImageURL: String = ""
    @Published var referalCode: String = ""
    @Published var hiveCommision: HiveCommision?
    @Published var hiveRank: HiveRank?
    @Published var showRankDetailBottomsheet: Bool = false
    @Published var honeyAmount: String = "0"
    @Published var honeyAmountValue: String = "0"
    @Published var lockedHoneyAmount: String = "0"
    @Published var lockedHoneyAmountValue: String = "0"
    @Published var isShowToaster: Bool = false
    @Published var shareReferralCodeText: String = ""
    @Published var shareReferralCodeUrl: String = ""
    @Published private(set) var commision: HiveRankCommision?
    @Published var totalNectars: String = "0"
    @Published var hiveOnboardingAssetViewModel = HiveOnboardingAssetViewModel()
    @Published var shouldShowWelcomeView: Bool = false
    
    private var toasterDismissTimer: Timer?
    
    var rankIcon: String {
        if isShowCountDown {
            return "free-trial-rank"
        } else {
            switch hiveRank?.tier {
            case 1: return "new-bee-rank"
            case 2: return "worker-bee-rank"
            case 3: return "royal-bee-rank"
            default : return ""
            }
        }
    }
    
    var isActive: Bool {
        hiveRank?.activeStatus ?? false
    }
    
    var isShowCommissionView: Bool {
        if isActive {
            return hiveRank?.tier != 3
        }
        else {
            return true
        }
    }
    
    var isShowCountDown: Bool {
        guard let hiveRank = hiveRank else { return false }
        return hiveRank.isTrial
    }
    
    var trialCountDown: Int {
        guard let hiveRank = hiveRank else { return 0 }
        return hiveRank.trialCountdown
    }
    
    var tierNameText: String {
        if isShowCountDown {
            return "Free Trial"
        }
        
        if let tierName = hiveRank?.tierName, isActive {
            return tierName
        }
        
        return "Inactive"
    }
    
    var accountTypeText: String {
        if isShowCountDown { return "FREE TRIAL"}
        return isActive ? "ACTIVE" : "INACTIVE"
    }
    
    var accountTypeChipColor: Color {
        if isShowCountDown { return HiveColors.pacmanYellow}
        return isActive ? Color.appGreen : Color.elmoRed500
    }
    
    var accountTypeForegroundColor: Color {
        if isShowCountDown { return Color.black}
        return isActive ? Color.black : Color.white
    }
    
    var commissionTitle: String {
        if isShowCountDown {
            return "Upgrade your account to start enjoying your rewards"
        }
        
        if let generalComission = commision?.generalComission, isActive {
            return generalComission
        }
        
        return "Activate now to start earning with Bytes Hive"
    }
    
    var commissionSubtitle: String {
        isActive ? "Upgrade Now" : "Activate Now"
    }
    
    var isRoyalBee: Bool {
        return hiveRank?.tier == 3
    }
    
    var rankBackgroundColors: [Color] {
        if isRoyalBee {
            return [Color(hex: "#5D5317"), HiveColors.mainYellow, Color(hex: "#FFDE02"), Color.white]
        }
        return [ Color.white.opacity(0.05) ]
    }
    
    var shareReferralText: String {
        StringRepository.hiveShareReferralText.getString().replacingOccurrences(of: "{username}", with: username.uppercased())
    }
    
    // MARK: - Services
    private let authService: AuthServiceProtocol
    private let hiveService: HiveServiceProtocol
    private let milesService: MilesServiceProtocol
    private let staticService: StaticAssetsServiceProtocol
    
    internal init(
        hiveService: HiveServiceProtocol,
        milesService: MilesServiceProtocol,
        authService: AuthServiceProtocol,
        staticService: StaticAssetsServiceProtocol
    ) {
        self.authService = authService
        self.hiveService = hiveService
        self.milesService = milesService
        self.staticService = staticService
    }
    
    // MARK: - Functions
    static func new() -> HiveDashboardViewModel {
        return HiveDashboardViewModel(
            hiveService: HiveService(),
            milesService: MilesService(),
            authService: AuthService(),
            staticService: StaticAssetsService()
        )
    }
    
    func putHive() {
        Task { [weak self] in
            guard let self else { return }
            
            defer {
                fetchData()
            }
            
            do {
                let _ = try await self.hiveService.putHive()
            } catch let err as HttpError {
                handleError(err)
            }
        }
    }
    
    func showToaster() {
        // Cancel the previous timer if it exists
        toasterDismissTimer?.invalidate()
        toasterDismissTimer = nil
        
        // Show the toaster
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.isShowToaster = true
        }
        
        // Set a new timer to dismiss the toaster
        toasterDismissTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.isShowToaster = false
        }
    }
    
    // MARK: - Private Functions
    private func fetchData() {
        getHiveProfile()
        getHiveRank()
        getHiveSummary()
        getNectarsCount()
        fetchOnboardingAssets()
    }
    
    /// Get: Username, profile image, referal code
    private func getHiveProfile() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let account = try await self.authService.getMe()
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.username = account.username.uppercased()
                    self.profileImageURL = account.profileImageUrl
                    self.referalCode = account.referralCode
                    self.shareReferralCodeUrl = "https://bythen.ai/store?referral=\(account.referralCode)"
                }
            } catch let err as HttpError {
                self.handleError(err)
            }
        }
    }
    
    private func getHiveRank() {
        Task { [weak self] in
            guard let self else { return }
            defer {
                fetchRankRules()
            }
            
            do {
                let hiveRank = try await self.hiveService.getHiveRank()
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.hiveRank = hiveRank
                }
            } catch let err as HttpError {
                self.handleError(err)
            }
        }
    }
    
    private func getNectarsCount() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let nectarCount = try await self.milesService.getNectarsCount()
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.totalNectars = "\(nectarCount.totalNectar)"
                }
            } catch let err as HttpError {
                self.handleError(err)
            }
        }
    }
    
    private func getHiveSummary() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let commision = try await self.hiveService.getHiveSummary(page: 1, limit: 5, aggregate: true)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.hiveCommision = commision
                    self.honeyAmount = "\(commision.aggregate?.totalUnlockedPoint ?? 0)"
                    self.honeyAmountValue = "\(commision.aggregate?.totalUnlockedPointUSD ?? "0")"
                    self.lockedHoneyAmount = "\(commision.aggregate?.totalLockedPoint ?? 0)"
                    self.lockedHoneyAmountValue = "\(commision.aggregate?.totalLockedPointUSD ?? "0")"
                }
            } catch let err as HttpError {
                self.handleError(err)
            }
        }
    }
    
    internal func getHiveBottomsheetVM() -> HiveDashboardBottomSheetViewModel {
        let vm = HiveDashboardBottomSheetViewModel.new(rank: hiveRank ?? HiveRank())
        vm.dismissView = { [weak self] in
            guard let self else { return }
            self.showRankDetailBottomsheet = false
        }
        return vm
    }
    
    private func fetchRankRules() {
        Task { @MainActor in
            let staticService = StaticAssetsService()
            guard let response: HiveRankRulesResponse = try? await staticService.getAssets(path: .hiveRankRules) else { return }
            
            if let rank = hiveRank, rank.activeStatus {
                commision = response.commisions["\(rank.tier)"]
            } else {
                commision = response.commisions["inactive"]
            }
        }
    }
    
    private func fetchOnboardingAssets() {
        Task { @MainActor in
            let onboardingAssetsResponse: HiveOnboardingResponse = try await staticService.getAssets(path: .hiveOnboarding)
            
            hiveOnboardingAssetViewModel = HiveOnboardingAssetViewModel(hiveOnboardingResponse: onboardingAssetsResponse, username: AppSession.shared.getCurrentAccount()?.username)
            
            if AppSession.shared.shouldShowHiveGreeting() {
                shouldShowWelcomeView = true
                AppSession.shared.markHiveGreetingAsShown()
            } else {
                shouldShowWelcomeView = false
            }
        }
    }
}
