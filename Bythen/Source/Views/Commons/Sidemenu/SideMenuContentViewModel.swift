//
//  SideMenuContentViewModel.swift
//  Bythen
//
//  Created by edisurata on 25/09/24.
//

import Foundation

enum MenuPage {
    case chat
    case mycollection
    case logout
    case termsOfUse
    case freeTrialEnded
    case studio
    case accountSetup
    case profile
    case empty
    case hive
    case mission
    case hiveEarnings
    case hiveLeaderboard
}

class SideMenuContentViewModel: BaseViewModel {
    
    static func new() -> SideMenuContentViewModel {
        SideMenuContentViewModel(
            appSession: AppSession.shared,
            authService: AuthService(),
            byteBuildService: ByteBuildService(),
            byteService: ByteService(),
            analyticService: AnalyticService(),
            hiveService: HiveService()
        )
    }
    
    @Published var selectedPage: MenuPage = .empty
    @Published var isShowSideMenu = false
    @Published var showTrialCountdown: Bool = false
    @Published var trialCountdown: Int64 = 0
    @Published var trialTokenSymbol: String = ""
    @Published var isDarkMode: Bool = false
    @Published var menuConfig: SideMenuConfiguration = SideMenuConfiguration.default()
    @Published var isShowNotificationList: Bool = false
    @Published var notificationIconConfiguration: NotificationIconConfiguration = NotificationIconConfiguration(showNotificationIcon: false, showRedDot: false)
    
    var infoViewModel: SideMenuInfoViewModel { createProfileViewModel() }
    var chatroomViewModel: ChatroomViewModel?
    
    private var account: Account?
    private var appSession: AppSessionProtocol
    private var chatByteID: Int64?
    private var chatByteSymbol: String?
    private var trialCountdownTimer: Timer? = nil
    private var trial: FreeTrial?
    private var refreshFreeTrialTime: Int64 = 0
    private var isHasShowTrialEnded: Bool = false
    private var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "\(version).\(build)"
        }
        
        return ""
    }
    private var ishiveAfterLoginEnabled: Bool { FeatureFlag.releaseHiveAfterLogin.isFeatureEnabled() }
    
    private let authService: AuthServiceProtocol
    private let byteBuildService: ByteBuildServiceProtocol
    private let byteService: ByteServiceProtocol
    private let analyticService: AnalyticServiceProtocol
    private let hiveService: HiveServiceProtocol
    
    init(appSession: AppSessionProtocol, authService: AuthServiceProtocol, byteBuildService: ByteBuildServiceProtocol, byteService: ByteServiceProtocol, analyticService: AnalyticServiceProtocol, hiveService: HiveServiceProtocol) {
        self.appSession = appSession
        self.authService = authService
        self.byteBuildService = byteBuildService
        self.byteService = byteService
        self.analyticService = analyticService
        self.hiveService = hiveService
    }
    
    func fetchUserData(isFromBackground: Bool = false) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            do {
                let account = try await authService.getMe()
                handleAccount(account)
                
                let _ = try await byteBuildService.getBuildDefault()
                menuConfig = SideMenuConfiguration.default()
                
                determineInitialPage(isFromBackground)
            } catch let error {
                handleAuthError(error)
                
                fetchHiveIfNeeded(isFromBackground)
            }
        }
        
        doAdditionalTask()
    }
    
    func fetchNotificationStatus() {
        Task { @MainActor in
            notificationIconConfiguration.showNotificationIcon = FeatureFlag.sideMenuNotification.isFeatureEnabled()
            notificationIconConfiguration.showRedDot = await NotificationHelper.shared.getNotificationRedDot()
        }
    }
    
    func navigateToChatRoom(byteID: Int64, byteSymbol: String) {
        DispatchQueue.main.async {
            if byteSymbol != "" {
                self.chatByteID = byteID
                self.chatByteSymbol = byteSymbol
            }
            self.navigateToPage(.chat)
        }
    }
    
    func getChatroomViewModel() -> ChatroomViewModel {
        if self.chatroomViewModel == nil {
            self.chatroomViewModel = ChatroomViewModel.new()
        }
        
        if let byteID = self.chatByteID, let byteSymbol = self.chatByteSymbol {
            self.chatroomViewModel?.setParams(byteID: byteID, byteSymbol: byteSymbol)
        }
        
        return self.chatroomViewModel!
        
    }
    
    func navigateToPage(_ page: MenuPage) {
        if page == .empty { return }
        if page != .chat {
            self.chatroomViewModel = nil
        }
        DispatchQueue.main.async {
            self.selectedPage = page
        }
    }
    
    func logout(method: TrackingLoginMethod = .manual) {
        if let account = self.account {
            authService.authLogout(account: account)
        }
        analyticService.trackLogout(method: method)
        trialCountdownTimer?.invalidate()
        trialCountdownTimer = nil
        appSession.removeCurrentUser()
        WalletConnect.shared.disconnectWallet()
        chatroomViewModel = nil
        mainState?.viewPage = .onboarding
        selectedPage = .empty
    }
    
    func acceptTermsOfService(_ isAccepted: Bool, canBeContacted: Bool) {
        if isAccepted {
            Task {
                try await authService.acceptTermsOfService(canBeContacted)
                appSession.setAcceptedTermsOfService(true)
                
                redirectToInitialPage()
            }
        } else {
            logout(method: .force)
        }
    }
    
    func showSideMenu(_ show: Bool = true, isDarkMode: Bool = false) {
        isShowSideMenu = show
        self.isDarkMode = isDarkMode
    }
    
    func finishAccountSetup() {
        fetchUserData()
    }
    
    func checkFreeTrial() {
        self.showTrialCountdown = false
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let trial = try await self.byteService.getTrial()
                if trial.isTrialActive() {
                    self.updateTrial(trial)
                    if !trial.isTrialFinished && trial.trialCountdown > 0 {
                        self.showTrialCountdown = true
                        self.startCountdown()
                    } else if trial.isTrialActive() && trial.isTrialFinished && !trial.isEndDialogueDisplayed {
                        self.endFreeTrial()
                    }
                }
            } catch {
            }
        }
    }
}

// MARK: Private Functionalities
extension SideMenuContentViewModel {
    private func handleAuthError(_ error: Error) {
        if let _error = error as? HttpError, let code = _error.code, code == .unauthorized {
            logout(method: .force)
            return
        }
    }
    
    private func doAdditionalTask() {
        checkFreeTrial()
        trackEventDLU()
    }
    
    private func handleAccount(_ accountData: Account) {
        account = accountData
        appSession.setCurrentAccount(account: accountData)
        checkHiveOwnership()
    }
    
    private func checkHiveOwnership() {
        guard let account, !account.hasHive else {
            return
        }
        
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            do {
                let _ = try await hiveService.putHive()
            } catch {
               mainState?.viewPage = .invalidBytes
            }
        }
    }
    
    private func determineInitialPage(_ isFromBackground: Bool) {
        guard let account else {
            return
        }
        
        if !account.isProfileCompleted {
            selectedPage = .accountSetup
        } else if account.aggreementApprovedAt == nil {
            selectedPage = .termsOfUse
        } else {
            appSession.setAcceptedTermsOfService(true)
            redirectToInitialPage(isFromBackground)
        }
    }
    
    private func redirectToInitialPage(_ isFromBackground: Bool = false) {
        guard !isFromBackground else {
            return
        }
        
        if ishiveAfterLoginEnabled {
            // FIXME: Revert this to `hive`
            selectedPage = .hiveLeaderboard
        } else {
            selectedPage = .chat
        }
    }
    
    private func fetchHiveIfNeeded(_ isFromBackground: Bool) {
        guard !ishiveAfterLoginEnabled else {
            successFetchHive(isFromBackground)
            return
        }
        
        Task { @MainActor in
            do {
                let _ = try await hiveService.getHiveRank()
                
                successFetchHive(isFromBackground)
            } catch {
                mainState?.viewPage = .invalidBytes
            }
        }
    }
    
    private func successFetchHive(_ isFromBackground: Bool) {
        menuConfig = SideMenuConfiguration.hiveOnly()
        determineInitialPage(isFromBackground)
    }
    
    private func startCountdown() {
        // Start the timer
        if self.trialCountdownTimer != nil {
            return
        }
        
        self.trialCountdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: !self.isHasShowTrialEnded) { [weak self] _ in
            guard let self else { return }
            if self.trialCountdown > 0 {
                self.trialCountdown -= 1
                if var trial = self.trial {
                    trial.trialCountdown = self.trialCountdown
                    self.appSession.setTrial(trial)
                }
            } else {
                self.trialCountdownTimer?.invalidate()
                self.trialCountdownTimer = nil
                DispatchQueue.main.async {
                    self.endFreeTrial()
                }
            }
        }
    }
    
    private func updateTrial(_ trial: FreeTrial) {
        self.appSession.setTrial(trial)
        self.trial = trial
        self.trialCountdown = trial.trialCountdown
        self.refreshFreeTrialTime = trial.trialCountdown
        self.trialTokenSymbol = trial.originalTokenSymbol
    }
    
    private func endFreeTrial() {
        if self.selectedPage == .freeTrialEnded { return }
        self.showTrialCountdown = false
        self.selectedPage = .freeTrialEnded
        if var trial = self.trial {
            trial.trialCountdown = 0
            trial.isTrialFinished = true
            trial.isEndDialogueDisplayed = true
            self.appSession.setTrial(trial)
        }
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                try await self.byteService.updateTrialDialogue(isDisplay: true)
            }
        }
    }
    
    private func trackEventDLU() {
        if let account = self.appSession.getCurrentAccount() {
            Task { @MainActor in
                try await self.analyticService.trackDLU(accountID: account.accountID)
            }
        }
    }
    
    private func createProfileViewModel() -> SideMenuInfoViewModel {
        guard let accountData = AppSession.shared.getCurrentAccount() else {
            return SideMenuInfoViewModel()
        }
        
        return SideMenuInfoViewModel(
            name: accountData.username,
            imageURL: accountData.adjustedProfileImageUrl,
            walletAddress: accountData.walletAddress?.hiddenWalletAddress ?? "",
            appVersion: appVersion
        )
    }
}
