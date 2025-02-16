//
//  ProfileScreenViewModel.swift
//  Bythen
//
//  Created by Ega Setya on 16/12/24.
//

import SwiftUI

class ProfileScreenViewModel: BaseViewModel {
    @Published var viewState: ProfileScreenViewState = .idle
    @Published var profileImageURL: String = ""
    @Published var nicknameText: String  = ""
    @Published var walletAddresText: String = ""
    @Published var emailText: String  = ""
    @Published var telegramText: String  = ""
    @Published var twitterText: String  = ""
    @Published var emailErrorText: String = ""
    
    var fullWalletAddress: String = ""
    
    private let authService: AuthServiceProtocol
    private let mediaService: MediaService
    
    internal init(authService: AuthServiceProtocol, mediaService: MediaService) {
        self.authService = authService
        self.mediaService = mediaService
    }
    
    func didSelectNewProfileImage(_ attachment: Attachment) {
        uploadProfileImage(attachment.fileURL)
    }
    
    func checkTextFieldsValidation() {
        emailErrorText = ""
        
        if emailText.isTrulyEmpty || (telegramText.isTrulyEmpty && twitterText.isTrulyEmpty) {
            updateState(.invalid)
        } else {
            updateState(.valid)
        }
    }
    
    func submitSetupAccount() {
        guard emailText.isEmailValid else {
            emailErrorText = "Invalid Email Format"
            return
        }
        
        updateProfile()
    }
    
    func onAppear() {
        getAccountData()
    }
}

// MARK: Private Functions
extension ProfileScreenViewModel {
    private func getAccountData(forRefresh: Bool = false) {
        updateState(.loading)
        
        Task {
            do {
                let account = try await authService.getMe()
                AppSession.shared.setCurrentAccount(account: account)
                
                updateState(.dataRetrieved)
                
                assignProfileData(account)
            } catch let error as HttpError {
                updateState(.error(message: error.readableMessage))
            }
        }
    }
    
    private func assignProfileData(_ account: Account) {
        DispatchQueue.main.async {
            self.profileImageURL = account.adjustedProfileImageUrl
            self.nicknameText = account.username
            self.walletAddresText = account.walletAddress?.hiddenWalletAddress ?? ""
            self.fullWalletAddress = account.walletAddress ?? ""
            self.emailText = account.email
            self.telegramText = account.telegramUsername
            self.twitterText = account.twitterUsername
        }
    }
    
    private func uploadProfileImage(_ imageURL: URL) {
        updateState(.profileImageUploading)

        Task { @MainActor [weak self] in
            guard let self else { return }
            
            do {
                let media = try await self.mediaService.uploadImage(imageURL: imageURL)
                profileImageURL = media.url
                
                await syncProfileImage()
                
                updateState(.profileImageUdated)
            } catch let error as HttpError {
                updateState(.error(message: error.readableMessage))
                handleError(error)
            }
        }
    }
    
    private func updateProfile() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            updateState(.loading)
            
            do {
                let _ = try await authService.setupAccount(
                    json: [
                        "AccountID": AppSession.shared.getCurrentAccount()?.accountID ?? "",
                        "email": emailText,
                        "username": nicknameText,
                        "profile_image_url": profileImageURL,
                        "telegram_username": telegramText,
                        "twitter_username": twitterText
                    ]
                )
                
                updateState(.updated)
                
                syncAccountData()
            } catch let error as HttpError {
                handleUpdateProfileError(error)
            }
        }
    }
    
    private func syncProfileImage() async {
        Task {
            do {
                let _ = try await authService.setupAccount(
                    json: [
                        "profile_image_url": profileImageURL,
                    ]
                )
                
                syncAccountData()
            } catch let error as HttpError {
                updateState(.error(message: error.readableMessage))
            }
        }
    }
    
    private func syncAccountData() {
        Task {
            do {
                let account = try await authService.getMe()
                AppSession.shared.setCurrentAccount(account: account)
                
                assignProfileData(account)
            } catch let error as HttpError {
                updateState(.error(message: error.readableMessage))
            }
        }
    }
    
    private func handleUpdateProfileError(_ error: HttpError) {
        guard let infos = error.infos,
              let firstInfo = infos.first else {
            updateState(.error(message: error.readableMessage))
            return
        }
        
        updateState(.invalid)
        emailErrorText = firstInfo.message
    }
    
    private func updateState(_ newState: ProfileScreenViewState) {
        DispatchQueue.main.async {
            self.viewState = newState
        }
    }
}
