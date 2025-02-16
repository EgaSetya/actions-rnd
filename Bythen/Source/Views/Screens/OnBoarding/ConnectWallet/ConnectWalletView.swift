//
//  ConnectWalletView.swift
//  Bythen
//
//  Created by edisurata on 30/08/24.
//

import SwiftUI

struct ConnectWalletLoadingView: View {
    
    @State private var isAnimating: Bool = false
    @State var icon: String

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .frame(width: 90, height: 90)
                .foregroundColor(Color(hex: "#0E100F1A"))
            
            Circle()
                .trim(from: 0.0, to: 0.5)
                .stroke(lineWidth: 5)
                .frame(width: 90, height: 90)
                .foregroundColor(.black)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .onAppear {
                    withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        isAnimating = true
                    }
                }
            
            Image(icon)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.byteBlack)
                .frame(width: 32, height: 32)
        }
        
    }
}

struct ConnectWalletView: View {
    private let kSignTitle = "Sign to Verify"
    private let kSignDesc = "Sign the message in your wallet to verify it belongs to you."
    private let kSignButtonTitle = "SIGN WITH YOUR WALLET"
    
    @EnvironmentObject var mainState: MainViewModel
    
    @StateObject private var viewModel: ConnectWalletViewModel
    
    @State private var isViewReady = false
    
    init(viewModel: ConnectWalletViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isViewReady {
                Rectangle()
                    .fill(.clear)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isViewReady = false
                            viewModel.isCancelled = true
                            viewModel.cancelSign()
                        }
                    }
            }
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isViewReady = false
                        viewModel.isCancelled = true
                        viewModel.cancelSign()
                    }) {
                        Image("close")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(.byteBlack)
                            .frame(width: 15, height: 15)
                            .padding(16)
                    }
                    .padding()
                }
                
                ConnectWalletLoadingView(icon: "wallet")
                Text(kSignTitle)
                    .padding([.top], 24)
                    .padding(.horizontal)
                    .font(FontStyle.foundersGrotesk(.medium, size: 28))
                Text(kSignDesc)
                    .frame(maxWidth: .infinity, maxHeight: 48)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                    .padding(.top, 3)
                    .font(FontStyle.neueMontreal(.regular, size: 16))
                
                BasicSquareButton(title: kSignButtonTitle) {
                    viewModel.challenge()
                }
                .frame(height: 56)
                .padding(.horizontal)
                .padding(.top, 27)
                .padding(.bottom, 32)
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: 450)
            .background(.appCream)
            .cornerRadius(12)
            .shadow(radius: 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .onAppear(perform: {
            isViewReady = true
            viewModel.setMainState(state: mainState)
        })
    }
}

#Preview {
    var vm: ConnectWalletViewModel = ConnectWalletViewModel()
    
    return ConnectWalletView(viewModel: vm)
        .environmentObject(MainViewModel.new())
}
