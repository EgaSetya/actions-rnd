//
//  HiveWelcomeView.swift
//  Bythen
//
//  Created by Ega Setya on 06/01/25.
//

import SwiftUI

enum HiveWelcomeViewStep: Equatable {
    case greeting
    case invitation
    
    var title: String {
        switch self {
        case .greeting: "WELCOME TO YOUR HIVE!"
        case .invitation: "YOU'RE ALL SET UP"
        }
    }
    
    var mainButtonTitle: String {
        switch self {
        case .greeting: "CONTINUE"
        case .invitation: "JOIN TELEGRAM"
        }
    }
    
    func createDescriptionText(name: String) -> Text {
        switch self {
        case .greeting:
            Text("Congrats \(name)! You’re now officially part of Bytes Hive, Bythen’s community leveraging a revenue sharing model, where the majority of Bythen’s revenue is distributed daily to members—driving collective success.")
        case .invitation:
            Text("Now it's your turn to build your hive! Head over to our Telegram group to get the latest news, explore features and connect with fellow members. May your hive prosper!")
        }
    }
}


struct HiveWelcomeView: View {
    @Binding var viewModel: HiveOnboardingAssetViewModel
    @Binding var isShowing: Bool
    
    @State var step: HiveWelcomeViewStep = .greeting
    @State var videoPlayer: CustomVideoPlayer?
    @State var isMainButtonDisabled: Bool = false
    
    private var banner: some View {
        Group {
            switch step {
            case .greeting:
                videoPlayer
                    .frame(height: 200)
                    .padding(.top, 2)
                    .padding(.horizontal, 2)
            case .invitation:
                Image("telegram_banner")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: 230)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 0) {
                banner
                
                Text(step.title)
                    .font(.foundersGrotesk(.semibold, size: 32))
                    .foregroundStyle(.white)
                    .lineLimit(nil)
                    .padding(.top, 24)
                    .padding(.horizontal, 24)
                
                step.createDescriptionText(name: viewModel.name ?? "")
                    .font(.neueMontreal(.regular, size: 12))
                    .foregroundStyle(.white)
                    .lineLimit(nil)
                    .padding(.top, 12)
                    .padding(.horizontal, 24)
                
                CommonButton.basic(.rectangle, title: step.mainButtonTitle, colorScheme: .dark, isDisabled: $isMainButtonDisabled) {
                    mainButtonTapped()
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)
                .if(step == .greeting) { view in
                    view.padding(.bottom, 24)
                }
                
                if step == .invitation {
                    CommonButton.basic(.rectangle, title: "MAYBE LATER", colorScheme: .light) {
                        maybeLaterButtonTapped()
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 24)
                    .padding(.horizontal, 24)
                }
            }
            .background(
                Rectangle().fill(
                    .black,
                    strokeBorder: .white.opacity(0.1),
                    lineWidth: 2
                )
            )
            .onChange(of: viewModel) { newValue in
                videoPlayer = CustomVideoPlayer(url: newValue.videoURL)
            }
            .onChange(of: isMainButtonDisabled) { newValue in
                preventRapidTap(newValue)
            }
            .padding(.horizontal, 20)
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.5), value: step)
        .isHidden(!isShowing)
    }
    
    private func mainButtonTapped() {
        isMainButtonDisabled = true
        
        if step == .greeting {
            continueButtonTapped()
        } else {
            joinTelegramButtonTapped()
        }
    }
    
    private func preventRapidTap(_ newValue: Bool) {
        if newValue {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isMainButtonDisabled = false
            }
        }
    }
    
    private func continueButtonTapped() {
        step = .invitation
        videoPlayer?.stop()
    }
    
    private func joinTelegramButtonTapped() {
        guard let telegramGroupURL = viewModel.telegramGroupURL else {
            return
        }
        
        if UIApplication.shared.canOpenURL(telegramGroupURL) {
            UIApplication.shared.open(telegramGroupURL, options: [:], completionHandler: nil)
        }
        
        isShowing.toggle()
    }
    
    private func maybeLaterButtonTapped() {
        isShowing.toggle()
    }
}
