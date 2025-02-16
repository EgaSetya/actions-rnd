//
//  MissionScreenViewModel.swift
//  Bythen
//
//  Created by Darul Firmansyah on 31/12/24.
//

import Combine
import SwiftUI

class MissionScreenViewModel: BaseViewModel {
    private let paginationLimit: Int = 5
    // MARK: - Services
    private var authService: AuthServiceProtocol
    private var missionService: MissionServiceProtocol
    private var milesService: MilesServiceProtocol
    
    @Published
    var screenViewState: MissionScreenViewState = .pageLoading
    @Published
    var availableMissionState: MissionSectionState = .initialLoading
    @Published
    var completedMissionState: MissionSectionState = .initialLoading
    @Published
    var completedMissionCount: Int = 0
    @Published
    var bannerState: (shouldShow: Bool, type: DialogType, text: String, showCloseButton: Bool) = (false, .success, "", false)
    @Published
    var totalNectar: String? = nil
    @Published
    var isShowNectarTooltip: Bool = false
    @Published
    var availableMissions: [MissionDetailViewModel] = []
    @Published
    var completedMissions: [MissionDetailViewModel] = []
    @Published
    var isCountdownEnabled: Bool = false
    @Published
    var isTwitterPopupPresented: Bool = false
    @Published
    var showWebView: Bool = false
    
    var pendingMission: MissionDetailViewModel?
    var completedMissionPage: Int = 1
    var hasMoreCompletedMission: Bool = false
    var twitterAuthURL: URL?
    var goToPostURL: URL?
    
    init(
        authService: AuthServiceProtocol,
        missionService: MissionServiceProtocol,
        milesService: MilesServiceProtocol
    ) {
        self.authService = authService
        self.missionService = missionService
        self.milesService = milesService
        
        super.init()
    }
    
    convenience init() {
        self.init(authService: AuthService(), missionService: MissionService(), milesService: MilesService())
    }
    
    @MainActor
    func onAppear() async {
        do {
            let nectarCount: NectarCount = try await milesService.getNectarsCount()
            totalNectar = nectarCount.totalNectar.description
            screenViewState = .loaded
            
            // fetch mission sections
            fetchAvailableMissions()
            fetchCompletedMissions()
        } catch {
            totalNectar = 0.description
        }
        
        showTwitterConnectPopupIfNeeded()
    }
    
    func goToPost(for mission: MissionDetailViewModel) {
        goToPostURL = URL(string: String(format: MissionConstant.twitterPostURL, mission.postId))
        showWebView = true
    }
    
    func connectTwitter(oauthToken: String, oauthVerifier: String) {
        Task {
            do {
                let _ = try await authService.connectTwitter(oauthToken: oauthToken, oatuhVerifier: oauthVerifier)
                twitterAuthURL = nil
                showTwitterConnectPopupIfNeeded()
            } catch {
                showTwitterConnectPopupIfNeeded()
            }
        }
    }
    
    func onNectarInfoTapped() {
        isShowNectarTooltip.toggle()
    }
    
    @MainActor
    func loadMoreContent() async {
        guard hasMoreCompletedMission,
              completedMissionState == .idle
        else {
            return
        }
        
        fetchCompletedMissions()
    }
    
    func verifyMission(for mission: MissionDetailViewModel) async {
        Task { @MainActor in
            if let missionIndex: Int = availableMissions.firstIndex(of: mission) {
                availableMissions[missionIndex].buttonState = .verifying
                for index in 0 ..< mission.missionObjective.count {
                    availableMissions[missionIndex].missionObjective[index].state = .verifying
                }
                do {
                    availableMissions[missionIndex].buttonState = .verifying
                    let _ = try await missionService.postMissionObjectives(mission: mission)
                    pendingMission = mission
                    
                    //setup timer
                    fetchAvailableMissions()
                    fetchCompletedMissions()
                } catch {
                    for index in 0 ..< mission.missionObjective.count {
                        availableMissions[missionIndex].missionObjective[index].state = .incomplete
                    }
                    availableMissions[missionIndex].buttonState = .active
                }
            }
        }
    }
    
    func onTwitterConnect() {
        isTwitterPopupPresented = false
        attemptToConnectTwitter()
    }
    
    func showTwitterConnectPopupIfNeeded() {
        Task { @MainActor in
            let account = try await authService.getMe()
            let username = account.twitterUsername
            if username.isEmpty {
                isTwitterPopupPresented = true
            }
        }
    }
    
    private func disconnectTwitterIfNeeded() {
        Task { @MainActor in
            do {
                let _ = try await authService.disconnectTwitter()
                attemptToConnectTwitter()
            } catch {
                attemptToConnectTwitter()
            }
        }
    }
    
    private func attemptToConnectTwitter() {
        Task { @MainActor in
            if twitterAuthURL == nil {
                do {
                    let response = try await self.authService.authTwitter()
                    self.twitterAuthURL = URL(string: response.authorizationURI)
                    self.showWebView = true
                }
                catch let err {
                    self.bannerState = (true, .warning, (err as? HttpError)?.readableMessage ?? "Unable to connect to byte service. Please try again later.", true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.showTwitterConnectPopupIfNeeded()
                    }
                }
            }
            else {
                self.showWebView = true
            }
        }
    }
    
    private func fetchAvailableMissions() {
        Task { @MainActor in
            do {
                if availableMissions.isEmpty {
                    availableMissionState = .initialLoading
                }
                
                let missionsResponse = try await missionService.getAvailableMissions()
                availableMissions = missionsResponse.missions
                    .map({ MissionDetailViewModel(with: $0) { [weak self] missionId in
                        self?.onTimerElapsed(at: missionId)
                    }
                })
                
                if availableMissions.isEmpty {
                    availableMissionState = .empty
                }
                else {
                    availableMissionState = .idle
                }
                
                // check mission to show snackbar dialog
                checkPendingMission(mission: pendingMission, from: availableMissions)
            } catch {
                availableMissionState = .idle
            }
        }
    }
    
    private func fetchCompletedMissions() {
        Task { @MainActor in
            do {
                if completedMissions.isEmpty {
                    completedMissionState = .initialLoading
                }
                else {
                    completedMissionState = .paginationLoading
                }
                
                let missionsResponse = try await missionService.getCompletedMissions(page: completedMissionPage, limit: paginationLimit)
                let missions = missionsResponse.missions
                    .map({ MissionDetailViewModel(with: $0) { [weak self] missionId in
                        self?.onTimerElapsed(at: missionId)
                    }
                })
                
                completedMissionCount = missionsResponse.pagination.totalRecord ?? 0
                completedMissions += missions
                if let nextPage = missionsResponse.pagination.nextPage {
                    completedMissionPage = nextPage
                    hasMoreCompletedMission = true
                }
                else {
                    hasMoreCompletedMission = false
                }
                
                completedMissionState = .idle
                
                // check if page is empty
                if completedMissions.isEmpty {
                    completedMissionState = .empty
                }
                
                // check mission to show snackbar dialog
                checkPendingMission(mission: pendingMission, from: completedMissions)
            } catch {
                completedMissionState = .idle
            }
        }
    }
    
    private func checkPendingMission(mission: MissionDetailViewModel?, from list: [MissionDetailViewModel]) {
        guard let mission
        else {
            return
        }
        
        if let missionVM = list.first(where: { $0.id == mission.id }) {
            if missionVM.isCompleted {
                bannerState = (true, .errorSubtle, "Mission completed! You’ve earned \(missionVM.earnedNectar) Nectar", false)
            }
            else if missionVM.objectiveIncompleteCount > 0 {
                bannerState = (true, .errorSubtle, "Mission is not completed yet. Continue finishing your mission.", false)
            }
            
            pendingMission = nil
        }
    }
    
    private func onTimerElapsed(at missionId: Int) {
        withAnimation {
            availableMissions = availableMissions.filter({ $0.missionId != missionId })
        }
    }
}
