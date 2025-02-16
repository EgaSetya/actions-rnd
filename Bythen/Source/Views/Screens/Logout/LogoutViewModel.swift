//
//  LogoutViewModel.swift
//  Bythen
//
//  Created by edisurata on 31/08/24.
//

import Foundation
import SwiftUI
import Combine

class LogoutViewModel: BaseViewModel {
    @Published var countdown: Int = 5
    @Published var isLogoutDone: Bool = false
        
    private var logoutTimer: Timer?
    
    private lazy var authService: AuthService = AuthService()
    
    func startCountdown() {
        logoutTimer = Timer()
        logoutTimer = Timer.scheduledTimer(timeInterval: 1,
                                             target: self,
                                             selector: #selector(logoutTimerHandler),
                                             userInfo: nil,
                                             repeats: true)
    }
    
    func stopCountdown() {
        logoutTimer?.invalidate()
        isLogoutDone = true
    }
    
    @objc private func logoutTimerHandler(_ sender: Any) {
        if self.countdown <= 0 {
            self.stopCountdown()
            self.logout()
            return
        }
        
        DispatchQueue.main.async {
            self.countdown -= 1
        }
    }
    
   private func logout() {
       guard let account = AppSession.shared.getCurrentAccount() else { return }
       authService.authLogout(account: account)
       AppSession.shared.removeCurrentUser()
       WalletConnect.shared.disconnectWallet()
       self.mainState?.viewPage = .onboarding
    }
}
