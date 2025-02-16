//
//  ProfileScreen.swift
//  Bythen
//
//  Created by Ega Setya on 12/12/24.
//

import SwiftUI

enum ProfileScreenViewState: Equatable {
    case idle
    case loading
    case dataRetrieved
    case profileImageUploading
    case profileImageUdated
    case updated
    case error(message: String)
    case invalid
    case valid
}

struct ProfileScreen: View {
    @StateObject var viewModel: ProfileScreenViewModel
    @EnvironmentObject private var mainState: MainViewModel
    
    @State private var bannerState: (shouldShow: Bool, type: DialogType, text: String) = (false, .success, "")
    @State private var isUploadingProfileImage: Bool = true
    @State private var shouldOpenImagePicker: Bool = false
    @State private var shouldDeactivateApplyButton: Bool = false
    @State private var optionalPaddingBottom: CGFloat = 0
    @State private var showWalletAddressToolTip = false
    
    var sideMenu: some View {
        HStack(alignment: .top) {
            SideMenuButton()
                .padding(.top, -30)
                .padding(.horizontal, 12)
                .colorScheme(.dark)
            
            Spacer()
        }
        .zIndex(1)
    }
    
    var formContent: some View {
        Group {
            ZStack {
                sideMenu
                
                Image("profile-banner")
                    .resizable()
                    .frame(height: 194)
            }
            .padding(.bottom, -70)
            
            VStack(alignment: .leading, spacing: 0) {
                RemoteImage(urlString: $viewModel.profileImageURL, isLoading: $isUploadingProfileImage)
                    .overlay {
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(.white, lineWidth: 4)
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .contentShape(Circle())
                    .padding(.bottom, 16)
                    .onTapGesture {
                        shouldOpenImagePicker = true
                    }
                
                HStack {
                    Text(viewModel.nicknameText)
                        .font(FontStyle.foundersGrotesk(.medium, size: 32))
                    
                    Spacer()
                }
                
                HStack(spacing: 20) {
                    CommonButton.textIcon(.right(name: "copy-icon"), title: viewModel.walletAddresText) {
                        UIPasteboard.general.string = viewModel.fullWalletAddress
                        
                        showWalletToolTip()
                    }.attachSmallArrowedTooltip(isTooltipVisible: $showWalletAddressToolTip, content: "COPIED!")
                    
                    CommonButton.textIcon(.left(name: "disconnect-wallet"), title: "DISCONNECT") {
                        mainState.sidemenuContentVM?.logout()
                    }
                }
            }
            .padding(.bottom, 15)
            .padding(.leading, 16)
            
            Divider()
                .padding(.bottom, 6)
            
            FormSectionContainer(title: "Your Profile") {
                DisabledCheckedFormInput(title: "Nickname", text: viewModel.nicknameText)
            }
            
            FormSectionContainer(title: "Your Email") {
                FormInput(title: "Email Address", text: $viewModel.emailText, placeholder: "Enter email address", errorText: $viewModel.emailErrorText)
                    .keyboardType(.emailAddress)
                    .onChange(of: viewModel.emailText) { _ in
                        viewModel.checkTextFieldsValidation()
                    }
            }
            
            FormSectionContainer(title: "Social Accounts", subtitle: "For us to connect with you, fill in at least one of your social info.") {
                SocialFormInput(type: .telegram, text: $viewModel.telegramText)
                    .onChange(of: viewModel.telegramText) { newValue in
                        viewModel.checkTextFieldsValidation()
                    }
                SocialFormInput(type: .twitter, text: $viewModel.twitterText)
                    .onChange(of: viewModel.twitterText) { newValue in
                        viewModel.checkTextFieldsValidation()
                    }
            }
            
            HStack {
                CommonButton.basic(.rounded, title: "APPLY CHANGES", isDisabled: $shouldDeactivateApplyButton) {
                    hideKeyboard()
                    
                    viewModel.submitSetupAccount()
                }
                .frame(width: 149, height: 48, alignment: .leading)
                .padding(.vertical, 24)
                .padding(.horizontal, 16)
                
                Spacer()
            }
            .padding(.bottom, 24)
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                formContent
            }
            .adaptsToKeyboard()
            .ignoresSafeArea()
            .scrollIndicators(.hidden)
            .sheet(isPresented: $shouldOpenImagePicker) {
                ImagePicker(
                    didFinishPicking: { attachment in
                        viewModel.didSelectNewProfileImage(attachment)
                    },
                    didFailedValidation: {
                        bannerState = (true, .error, "The file exceeds the 20MB size limit. Please select a smaller file.")
                    }
                )
                .ignoresSafeArea(.all)
            }
            
            createBanner()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onChange(of: viewModel.viewState) { _ in
            bindViewState()
        }
    }
    
    private func createBanner() -> some View {
        Banner.dialog(
            type: bannerState.type,
            text: bannerState.text,
            isPresented: $bannerState.shouldShow
        )
        .padding(.horizontal, 20)
    }
    
    private func bindViewState() {
        let resetPageState = {
            self.mainState.showPageLoading(isLoading: false)
            self.isUploadingProfileImage = false
        }

        switch viewModel.viewState {
        case .loading:
            mainState.showPageLoading(isLoading: true)

        case .idle, .dataRetrieved:
            resetPageState()

        case .updated:
            resetPageState()
            bannerState = (true, .success, "Successfully updated profile")

        case .error(let errorMessage):
            resetPageState()
            bannerState = (true, .error, errorMessage)

        case .profileImageUploading:
            isUploadingProfileImage = true

        case .profileImageUdated:
            resetPageState()
            bannerState = (true, .success, "Successfully updated profile picture")

        case .valid:
            resetPageState()
            shouldDeactivateApplyButton = false

        case .invalid:
            resetPageState()
            shouldDeactivateApplyButton = true
        }
    }
    
    private func showWalletToolTip() {
        showWalletAddressToolTip = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showWalletAddressToolTip = false
        }
    }
}

#Preview {
    ProfileScreen(viewModel: ProfileScreenViewModel(authService: AuthService(), mediaService: DefaultMediaService()))
}
