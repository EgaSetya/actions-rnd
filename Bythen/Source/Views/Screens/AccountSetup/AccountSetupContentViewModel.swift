//
//  AccountSetupContentViewModel.swift
//  Bythen
//
//  Created by erlina ng on 13/11/24.
//
import SwiftUI

enum SocialMedia: String, CaseIterable {
    case twitter = "twitter_username"
    case telegram = "telegram_username"
}

internal enum UserInterest: String, CaseIterable {
    case content = "Content Creator"
    case reward = "Investor"
    case personal = "Casual User"
    case none
}

enum UserAccountErrorType: String {
    case email = "4005"
    case nickname = "4006"
}

class AccountSetupContentViewModel: BaseViewModel {
    @Published var nicknameTextfield: String  = ""
    @Published var emailTextfield: String  = ""
    @Published var socialMediaTextfield: String  = ""
    @Published var selectedSocialMedia: SocialMedia = .telegram
    @Published var selectedUserInterest: UserInterest = .none
    
    /// Error Property
    @Published var nicknameErrorMessage: String = ""
    @Published var emailErrorMessage: String = ""
    @Published var showNicknameError: Bool = false
    @Published var showEmailError: Bool = false
    
    var isFilled: Bool {
        return nicknameTextfield.isNotEmpty && emailTextfield.isNotEmpty && socialMediaTextfield.isNotEmpty && selectedUserInterest != .none
    }
    
    var selectedSocialMediaTitle: String {
        switch selectedSocialMedia {
//        case .discord: "Discord"
        case .telegram: "Telegram"
        case .twitter: "X/twitter"
        }
    }
    
    private var authService: AuthServiceProtocol
    
    internal init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    internal static func new() -> AccountSetupContentViewModel {
        AccountSetupContentViewModel(authService: AuthService())
    }
    
    internal func submitSetupAccount( onComplete: @escaping () -> Void ) {
        let isEmailValid = emailTextfield.isEmailValid
        if !isEmailValid {
            emailErrorMessage = "Invalid Email Format"
            showEmailError = true
        }
        if nicknameTextfield.count < 3 {
            nicknameErrorMessage = "Please enter at least 3 characters to continue."
            showNicknameError = true
        }
        
        if isEmailValid, nicknameTextfield.count >= 3 {
            saveSetupAccount(onComplete: onComplete)
        }
    }
    
    private func saveSetupAccount( onComplete: @escaping () -> Void ) {
        Task { [weak self] in
            guard let self else { return }
            defer {
                self.setLoading(isLoading: false)
            }
            self.setLoading(isLoading: true)
            do {
                let _ = try await self.authService.setupAccount(
                    json: [
                        "username" : nicknameTextfield,
                        "is_profile_completed" : true,
                        "\(selectedSocialMedia.rawValue)" : socialMediaTextfield,
                        "interest": selectedUserInterest.rawValue,
                        "email": emailTextfield
                    ]
                )   
                
                DispatchQueue.main.async {
                    onComplete()
                }
            } catch let err as HttpError {
                DispatchQueue.main.async {
                    self.handleError(from: err)
                }
            }
        }
    }
    
    internal func setNameLimit(newValue: String) { ///Maximum length for nickname is 15
        nicknameTextfield = String(newValue.prefix(15))
    }
    
    internal func restrictNameInput() { /// To restrict username's character
        nicknameTextfield = nicknameTextfield.filter { char in
            char.isLetter || char.isNumber || char == "-" || char == "_" || char == "."
        }
    }
    
    private func handleError(from error: HttpError) {
        guard let errors = error.infos else {
            handleError(error)
            return
        }
        
        errors.compactMap { error -> UserAccountErrorType? in
            guard let type = UserAccountErrorType(rawValue: error.id) else {
                return nil
            }
            
            return type
        }.forEach { type in
            switch type {
            case .email:
                emailErrorMessage = error.message
                showEmailError = true
            case .nickname:
                nicknameErrorMessage = error.message
                showNicknameError = true
            }
        }
    }
}
