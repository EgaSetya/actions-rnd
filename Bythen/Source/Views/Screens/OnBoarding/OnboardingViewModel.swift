//
//  OnboardingViewModel.swift
//  Bythen
//
//  Created by edisurata on 30/08/24.
//

import Combine
import Foundation

class OnboardingViewModel: BaseViewModel {
    
    static func new() -> OnboardingViewModel { OnboardingViewModel() }
    
    @Published var isPresentSignModal: Bool = false
    @Published var isAuthLoginSuccess: Bool = false
    @Published var isEnableLoginWithEmail: Bool = FeatureFlag.loginWithEmail.isFeatureEnabled()
    
    
    private var cancellables = Set<AnyCancellable>()
    private(set) var connectWalletVM: ConnectWalletViewModel

    init() {
        connectWalletVM = ConnectWalletViewModel()
        super.init()
        if connectWalletVM.isWalletConnected {
            isPresentSignModal = true
        }
        connectWalletVM.$isWalletConnected.sink { [weak self] value in
            guard let self = self else { return }
            if value {
                self.isPresentSignModal = true
            }
        }.store(in: &cancellables)
        connectWalletVM.$isAccountAuthorized.sink { [weak self] value in
            guard let self = self else { return }
            if value {
                self.isPresentSignModal = false
                self.isAuthLoginSuccess = true
            }
        }.store(in: &cancellables)
        connectWalletVM.$isCancelled.sink { [weak self] value in
            guard let self = self else { return }
            if value {
                self.isPresentSignModal = false
            }
        }.store(in: &cancellables)
    }
    
    func getLoginEmailViewModel() -> LoginEmailViewModel {
        let vm = LoginEmailViewModel.new()
        vm.setupCallbacks { account in
            self.isAuthLoginSuccess = true
        }
        return vm
    }
    
    func fetchFF(retry: Int = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            self.isEnableLoginWithEmail = FeatureFlag.loginWithEmail.isFeatureEnabled()
            
            if !self.isEnableLoginWithEmail && retry < 10 {
                self.fetchFF(retry: retry + 1)
            }
        }
    }
}
