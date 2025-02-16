//
//  connectWalletView.swift
//  Bythen
//
//  Created by edisurata on 30/08/24.
//

import Foundation
import Combine

class ConnectWalletViewModel: BaseViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isAccountAuthorized = false
    @Published var isWalletConnected = false
    @Published var isAccountSigned = false
    @Published var isCancelled = false
    @Published var walletProviderIcon = ""
    
    lazy var authService: AuthService = AuthService()
    private var walletAddress: String = ""
    private var signature: String = ""
    private var nonce: String = ""
    private var authAccount: Account?
    
    init() {
        super.init()
        setupWalletConnectObserver()
//        if let address = WalletConnect.shared.getConnectedAccountAddress() {
//            walletAddress = address
//            isWalletConnected = true
//        }
//        
//        if let icon = WalletConnect.shared.getConnectedPeerIconName() {
//            walletProviderIcon = icon
//        } else {
//            walletProviderIcon = "metamask"
//        }
    }
    
    private func setupWalletConnectObserver() {
        WalletConnect.shared.walletConnectedPublisher.sink { [weak self] walletAddress in
            guard let self = self else { return }
            self.walletAddress = walletAddress
            self.isWalletConnected = true
        }.store(in: &cancellables)
        
        WalletConnect.shared.accountSignedPublisher.sink { [weak self] signature in
            guard let self = self else { return }
            self.isAccountSigned = true
            self.signature = signature
            self.walletProviderIcon = "wallet-connected"
            self.isLoading = false
            self.login()
        }.store(in: &cancellables)
    }
    
    func challenge() {
        Task { [weak self] in
            guard let self = self else {return}
            do {
                self.nonce = try await authService.challenges(address: self.walletAddress)
                WalletConnect.shared.signWithConnectedAccount(nonce: self.nonce)
            } catch let err as HttpError {
                self.handleError(err)
            } catch let err {
                self.handleError(err)
            }
        }
    }
    
    func cancelSign() {
        WalletConnect.shared.disconnectWallet()
    }
    
    private func login() {
        print("address: \(walletAddress), nonce: \(nonce), signature: \(signature)")
        
        Task { [weak self] in
            guard let self = self else {return}
            
            do {
                var account = try await authService.authLogin(address: self.walletAddress, nonce: self.nonce, signature: self.signature, referralCode: nil)
                
                account.walletAddress = self.walletAddress
                self.authAccount = account
                AnalyticService.shared.trackLogin(accountID: account.loginAccountID)
                AppSession.shared.setAuthToken(authToken: account.accessToken)
                let me = try await self.authService.getMe()
                AppSession.shared.setCurrentAccount(account: me)
                NotificationHelper.shared.registerPushNotification()
                self.nonce = ""
                self.signature = ""
                DispatchQueue.main.async {
                    self.walletProviderIcon = "wallet-connected"
                    self.isAccountAuthorized = true
                }
            } catch let err as HttpError {
                self.handleError(err)
            } catch let err {
                self.handleError(err)
            }
        }

    }
}
