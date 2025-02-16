//
//  IntroView.swift
//  Bythen
//
//  Created by edisurata on 28/08/24.
//

import SwiftUI
import ReownAppKit
import Combine

struct Onboarding1View: View {
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Image("onboarding1")
                    .resizable()
                    .scaledToFit()
                    .padding([.bottom], 200)
                    .padding([.top], 80)
                
                Spacer()
            }
            
            Spacer()
        }
        .background(Color(hex: "#E9E7DE"))
        .ignoresSafeArea()
    }
}

struct Onboarding2View: View {
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Image("onboarding2")
                    .resizable()
                    .scaledToFit()
                    .padding([.bottom], 200)
                    .padding([.top], 80)
                
                Spacer()
            }
            Spacer()
        }
        .background(Color(hex: "#E581D2"))
        .ignoresSafeArea()
    }
}

struct Onboarding3View: View {
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Image("onboarding3")
                    .resizable()
                    .scaledToFit()
                    .padding([.bottom], 200)
                    .padding([.top], 80)
                Spacer()
            }
            
            Spacer()
        }
        .background(Color(hex: "#8D86F3"))
        .ignoresSafeArea()
    }
}

struct OnboardingView: View {
    @EnvironmentObject var mainState: MainViewModel
    
    @StateObject var viewModel: OnboardingViewModel
    @State private var selectedTab = 0
    static private let indicatorWidth = (UIScreen.main.bounds.width - 42) / 3
    @State private var pageIndicatorOffset: CGFloat = 0
    @State private var isPresentConnectWalletModal: Bool = false
    @State private var isShowLoginEmailView: Bool = false
    private var selectedBackground: String {
        switch selectedTab {
        case 1 : return "#F0B1E5"
        case 2 : return "#A9A9F8"
        case 3 : return "#F6FD8B"
        default : return "E9E7DE"
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Color.appBlack.opacity(0.1)
                        .frame(height: 3)

                    Color.appBlack.opacity(0.1)
                        .frame(height: 3)

                    Color.appBlack.opacity(0.1)
                        .frame(height: 3)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 19)
                
                HStack {
                    MarqueeView(targetVelocity: 50, spacing: 0) {
                        HStack {
                            bannerView
                            bannerView
                            bannerView
                            bannerView
                            bannerView
                            bannerView
                        }
                    }
                    .background(Color.gokuOrange400)
                }
                Spacer()
            }
            
            TabView(selection: $selectedTab) {
                NewOnboarding1View().tag(0)
                
                AnimationOnboardingView(
                    textImage: .onboarding2Text,
                    decorationImages: .onboarding2Decoration,
                    charactherImage: .onboarding2Character
                ).tag(1)
                
                AnimationOnboardingView(
                    textImage: .onboarding3Text,
                    decorationImages: .onboarding3Decoration,
                    charactherImage: .onboarding3Character
                ).tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .ignoresSafeArea()
            .onChange(of: selectedTab) { newValue in
                withAnimation {
                    pageIndicatorOffset = CGFloat(newValue) * OnboardingView.indicatorWidth + CGFloat(newValue) * 5
                }
            }
            
            VStack {
                Color.appBlack
                    .frame(width: ((UIScreen.main.bounds.width - 42) / 3), height: 3)
                    .offset(x: pageIndicatorOffset)
                    .padding(.top, 16)
                    .animation(.linear(duration: 0.2), value: pageIndicatorOffset)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal, 16)
            Spacer()
            VStack {
                Button {
                    AppKit.present()
                } label: {
                    HStack {
                        Spacer()
                        Image("wallet")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 16, height: 12)
                            .foregroundStyle(.white)
                        Text("CONNECT WALLET")
                            .font(.foundersGrotesk(.semibold, size: 18))
                            .foregroundStyle(.white)
                            .padding(.vertical, 16)
                        Spacer()
                    }
                }
                .background(.byteBlack)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
                
                if viewModel.isEnableLoginWithEmail {
                    Button(action: {
                        self.isShowLoginEmailView = true
                    }) {
                        Text("OR CONTINUE WITH EMAIL")
                            .foregroundColor(.appBlack)
                            .font(FontStyle.foundersGrotesk(.semibold, size: 16))
                            .underline()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 50)
        
            if viewModel.isPresentSignModal {
                ConnectWalletView(viewModel: viewModel.connectWalletVM)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: .bottom))
                    .padding(.bottom, 0)
                    .zIndex(1.0)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .background(Color(hex: selectedBackground))
        .animation(.easeInOut, value: viewModel.isPresentSignModal)
        .onAppear(perform: {
            viewModel.setMainState(state: mainState)
            viewModel.fetchFF()
        })
        .sheet(isPresented: $isShowLoginEmailView) {
            LoginEmailView(viewModel: viewModel.getLoginEmailViewModel())
                .presentationDetents([.height(320), .large])
        }
    }
    
    var bannerView: some View {
        HStack(spacing: 8) {
            Text("BYTHEN.AI")
                .font(Font.foundersGrotesk(.bold, size: 19))
                .frame(width: 110)
            Image(systemName: "globe")
        }
        .padding(.vertical, 9)
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel.new())
        .environmentObject(MainViewModel.new())
}
