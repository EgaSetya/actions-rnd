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
    case twitterConnectSuccess(message: String)
    case showTwitterWebView
}

struct ProfileScreen: View {
    @StateObject var viewModel: ProfileScreenViewModel
    @EnvironmentObject private var mainState: MainViewModel
    @EnvironmentObject private var sideMenuRouter: SideMenuRouter
    
    @State private var bannerState: (shouldShow: Bool, type: DialogType, text: String) = (false, .success, "")
    @State private var isUploadingProfileImage: Bool = true
    @State private var shouldOpenImagePicker: Bool = false
    @State private var shouldDeactivateApplyButton: Bool = false
    @State private var optionalPaddingBottom: CGFloat = 0
    @State private var showWalletAddressToolTip = false
    @State private var showSolanaWalletView = false
    @State private var showTwitterDisconnectConfirmationModal = false
    @State private var showTwitterWebView = false
    
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
                    .scaledToFill()
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
                        viewModel.terminateSession()
                    }
                }
            }
            .padding(.leading, 16)
            
            Divider()
                .padding(.bottom, 6)
            
            FormSectionContainer(title: "Your Profile") {
                DisabledCheckedFormInput(title: "Nickname", text: viewModel.nicknameText)
            }
            
            createEmailField()
            
            FormSectionContainer(title: "Social Accounts", subtitle: "For us to connect with you, fill in at least one of your social info.") {
                SocialFormInput(type: .telegram, text: $viewModel.telegramText)
                    .onChange(of: viewModel.telegramText) { newValue in
                        viewModel.checkTextFieldsValidation()
                    }
                
                twitterSection
            }
            
            solanaSection
            
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
    
    @ViewBuilder
    private var twitterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center) {
                Image("twitter-icon")
                    .frame(square: 24)
                
                Text("Twitter")
                    .font(.neueMontreal(.medium, size: 18))
                    .foregroundStyle(.byteBlack)
            }
            
            
            if viewModel.isTwitterExist {
                HStack(alignment: .bottom, spacing: 0) {
                    InputField.disabled(text: viewModel.twitterText, type: .checked)
                    
                    CommonButton.basic(.roundBordered, title: "UPDATE X ACCOUNT", colorScheme: .dark) {
                        showTwitterDisconnectConfirmationModal.toggle()
                    }
                    .frame(maxWidth: 171)
                    .frame(height: 48, alignment: .trailing)
                    .padding(.leading, 12)
                }
            } else {
                HStack {
                    Text("Connect X to access additional features.")
                        .font(.neueMontreal(size: 16))
                        .lineLimit(2)
                        .foregroundStyle(Color.byteBlack400)
                        .frame(maxWidth: 252, alignment: .leading)
                    
                    Spacer()
                    
                    CommonButton.basic(.rounded, title: "CONNECT", backgroundColor: .gokuOrange600) {
                        viewModel.authorizeTwitter()
                    }
                    .frame(maxWidth: 100)
                    .frame(height: 36, alignment: .trailing)
                }
            }
        }
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private var solanaSection: some View {
        FormSectionContainer(title: "Your Solana Wallet") {
            if viewModel.isSolanaAddressExist {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Wallet Address")
                        .font(.dmMono(size: 16))
                        .foregroundStyle(.byteBlack)
                    
                    HStack(alignment: .bottom, spacing: 0) {
                        Image("icon-solana-with-background")
                            .frame(square: 48)
                        
                        InputField.disabled(text: viewModel.solanaWalletAddressText, type: .checked)
                            .truncationMode(.middle)
                        
                        CommonButton.basic(.roundBordered, title: "UPDATE WALLET", colorScheme: .dark) {
                            showSolanaWalletView.toggle()
                        }
                        .frame(maxWidth: 140)
                        .frame(height: 48, alignment: .trailing)
                        .padding(.leading, 12)
                    }
                }
            } else {
                HStack {
                    Text("Connect Solana Wallet to access additional features")
                        .font(.neueMontreal(size: 16))
                        .lineLimit(2)
                        .foregroundStyle(Color.byteBlack400)
                        .frame(maxWidth: 252, alignment: .leading)
                    
                    Spacer()
                    
                    CommonButton.basic(.rounded, title: "CONNECT", backgroundColor: .gokuOrange600) {
                        showSolanaWalletView.toggle()
                    }
                    .frame(maxWidth: 100)
                    .frame(height: 36, alignment: .trailing)
                }
            }
        }
    }
    
    private var twitterDisconnectConfirmationPopUp: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .frame(square: 54)
                .foregroundStyle(.elmoRed500)
            
            Text("Important Notice")
                .font(.foundersGrotesk(.medium, size: 28))
                .foregroundStyle(.byteBlack)
                .padding(.top, 16)
            
            Text("To update your X account, you must first disconnect your current one. Please note: certain features will be unavailable until you connect a new X account.")
                .multilineTextAlignment(.center)
                .font(.neueMontreal(size: 16))
                .foregroundStyle(.byteBlack)
                .padding(.top, 4)

            CommonButton.basic(.rectangle, title: "DISCONNECT X ACCOUNT") {
                viewModel.disconnectTwitter()
                
                showTwitterDisconnectConfirmationModal.toggle()
            }
            .padding(.top, 48)
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 28)
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
        .overlay(alignment: .bottom) {
            BottomSheet(
                isShowing: $showSolanaWalletView,
                type: .plain,
                backgroundColor: .white,
                content: AnyView(
                    SolanaConnectView(
                        viewModel: SolanaConnectViewModel.new(),
                        bannerState: $bannerState
                    ) {
                        showSolanaWalletView.toggle()
                    }
                )
            )
        }
        .overlay(alignment: .bottom) {
            BottomSheet(
                isShowing: $showTwitterDisconnectConfirmationModal,
                type: .closable,
                backgroundColor: .white,
                content: AnyView(
                    twitterDisconnectConfirmationPopUp
                )
            )
        }
        .fullScreenCover(isPresented: $showTwitterWebView) {
            if let url = viewModel.twitterAuthURL {
                MissionWebViewContainer(showWebView: $showTwitterWebView, url: url, delegate: self)
            }
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
            mainState.showPageLoading(isLoading: false)
            isUploadingProfileImage = false
            showTwitterWebView = false
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
        
        case .twitterConnectSuccess(let message):
            bannerState = (true, .success, message)
            
        case .showTwitterWebView:
            showTwitterWebView = true
        }
    }
    
    private func showWalletToolTip() {
        showWalletAddressToolTip = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showWalletAddressToolTip = false
        }
    }
    
    @ViewBuilder
    private func createEmailField() -> some View {
        FormSectionContainer(title: "Your Email") {
            if viewModel.isEmailVerified {
                DisabledCheckedFormInput(title: "Email Address", text: viewModel.emailText)
            } else {
                FormInput(title: "Email Address", text: $viewModel.emailText, placeholder: "Enter email address", errorText: $viewModel.emailErrorText)
                    .keyboardType(.emailAddress)
                    .onChange(of: viewModel.emailText) { _ in
                        viewModel.checkTextFieldsValidation()
                    }
            }
        }
    }
    
    private func hideTwitterWebView() {
        viewModel.viewState = .idle
    }
}

extension ProfileScreen: MissionWebViewDelegate {
    func onAuthorized(oauthToken: String, oauthVerifier: String) {
        hideTwitterWebView()
        viewModel.connectTwitter(oauthToken: oauthToken, oauthVerifier: oauthVerifier)
    }
    
    func onCancel() {
        hideTwitterWebView()
    }
    
    func onRejected() {
        hideTwitterWebView()
    }
}

#Preview {
    ProfileScreen(viewModel: ProfileScreenViewModel(authService: AuthService(), mediaService: DefaultMediaService()))
}
