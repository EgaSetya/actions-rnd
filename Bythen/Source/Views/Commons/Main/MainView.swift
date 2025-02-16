//
//  ContentView.swift
//  Bythen
//
//  Created by edisurata on 13/09/24.
//

import SwiftUI
#if DEV || STAGING
    import FLEX
#endif

struct MainView: View {
    @StateObject private var viewModel = MainViewModel.new()

    @State private var isEditingMode = false

    var body: some View {
        ZStack {
            switch viewModel.viewPage {
            case .onboarding:
                OnboardingView(viewModel: viewModel.getOnboardingVM())
            case .main:
                SideMenuContentView(viewModel: viewModel.getSidemenuVM())
            case .invalidBytes:
                InvalidBytesView()
            }

            if viewModel.isEditiing {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            viewModel.isEditiing = false
                            hideKeyboard()
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
            }

            if viewModel.isPageLoading {
                VStack {
                    NetworkProgressView()
                        .zIndex(2)
                }
                .background(.byteBlack.opacity(0.1))
            }

            if viewModel.isShowErrorAlert {
                GeometryReader { geo in
                    HStack {
                        Spacer()
                        ErrorTickerView(
                            isPresent: $viewModel.isShowErrorAlert,
                            message: viewModel.errorMsg
                        )
                        .padding()
                        .frame(maxWidth: geo.size.width - 100)
                        .zIndex(1)
                        .padding(.top, 50)
                    }
                }
            }
        }
        .environmentObject(viewModel)
        .onAppear {
            viewModel.fetchData()
        }
        #if DEV || STAGING
        .onShake {
                FLEXManager.shared.showExplorer()
            }
        #endif
    }
}
