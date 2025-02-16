//
//  ContentViewModel.swift
//  Bythen
//
//  Created by edisurata on 25/09/24.
//

import Foundation

enum MainViewPage {
    case onboarding
    case main
    case invalidBytes
}

class MainViewModel: ObservableObject {
    static func new() -> MainViewModel {
        return MainViewModel(appSession: AppSession.shared)
    }

    @Published var viewPage: MainViewPage = .onboarding

    @Published var isShowErrorAlert: Bool = false
    @Published var errorMsg: String = ""

    @Published var isEditiing = false
    @Published var isPageLoading = false
    
    @Published var voiceStatus = ""
    
    var sidemenuContentVM: SideMenuContentViewModel?
    var onboardingViewModel: OnboardingViewModel?

    var appSession: AppSessionProtocol

    init(appSession: AppSessionProtocol) {
        self.appSession = appSession
    }
    
    func preloadLatestAvatar() {
        if let traits = self.appSession.getLastTraits() {
            UnityApi.shared.startAvatar(traits)
        }
    }

    func fetchData() {
        if let _ = appSession.getCurrentAccount() {
            viewPage = .main
            preloadLatestAvatar()
        } else {
            viewPage = .onboarding
        }
    }

    func showPageLoading(isLoading: Bool) {
        DispatchQueue.main.async {
            self.isPageLoading = isLoading
        }
    }

    func showError(errMsg: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.errorMsg = errMsg
            self.isShowErrorAlert = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            self.errorMsg = ""
            self.isShowErrorAlert = false
        }
    }

    func getOnboardingVM() -> OnboardingViewModel {
        if self.onboardingViewModel == nil {
            self.onboardingViewModel = OnboardingViewModel.new()
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                for await isAuthorize in self.onboardingViewModel!.$isAuthLoginSuccess.values {
                    if isAuthorize {
                        self.viewPage = .main
                    }
                }
            }
        }
        
        return self.onboardingViewModel!
    }

    func getSidemenuVM() -> SideMenuContentViewModel {
        if self.sidemenuContentVM == nil {
            self.sidemenuContentVM = SideMenuContentViewModel.new()
        }
        
        return self.sidemenuContentVM!
    }
}
