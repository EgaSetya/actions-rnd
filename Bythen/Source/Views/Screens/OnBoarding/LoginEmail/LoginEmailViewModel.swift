//
//  LoginEmailViewModel.swift
//  Bythen
//
//  Created by edisurata on 17/10/24.
//

import Foundation
import Combine

class LoginEmailViewModel: BaseViewModel {
    
    static func new() -> LoginEmailViewModel {
        return LoginEmailViewModel(authService: AuthService(), appSession: AppSession.shared)
    }
    
    // MARK: - Obserable Property
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isEnableLogin: Bool = false
    
    // MARK: - Services
    private var authService: AuthServiceProtocol
    private var appSession: AppSessionProtocol
    
    // MARK: - Callbacks
    private var didSuccessLogin: (Account) -> Void = { _ in }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthServiceProtocol, appSession: AppSessionProtocol) {
        self.authService = authService
        self.appSession = appSession
        
        super.init()
        
        self.observeLoginEnable()
    }
    
    func setupCallbacks(didSuccessLogin: @escaping (Account) -> Void) {
        self.didSuccessLogin = didSuccessLogin
    }
    
    func loginWithEmail() {
        #if DEV || STAGING
        self.debugLoginWithEmail()
        #else
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            defer {
                self.setLoading(isLoading: false)
            }
            
            self.setLoading(isLoading: true)
            
            if !self.validateLoginWithEmail() { return }
            do {
                var account = try await self.authService.loginWithEmail(email: self.email, password: self.password)
                self.appSession.setAuthToken(authToken: account.accessToken)
                let me = try await self.authService.getMe()
                self.appSession.setCurrentAccount(account: me)
                self.didSuccessLogin(account)
            } catch {
                self.handleError(error)
            }
        }
        #endif
    }
    
    private func observeLoginEnable() {
        self.$email.combineLatest(self.$password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (email, password) in
                guard let self else { return }
                self.isEnableLogin = validateLoginWithEmail()
            }
            .store(in: &cancellables)
    }
    
    private func validateLoginWithEmail() -> Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    private func debugLoginWithEmail() {
        AppSession.shared.setAuthToken(authToken: TestingAccessToken.shared.haveAllUser)
        
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            let me = try await self.authService.getMe()
            AppSession.shared.setCurrentAccount(account: me)
            NotificationHelper.shared.registerPushNotification()
            self.didSuccessLogin(me)
        }
        
    }
}
