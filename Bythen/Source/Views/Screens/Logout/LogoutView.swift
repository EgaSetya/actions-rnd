//
//  LogoutView.swift
//  Bythen
//
//  Created by edisurata on 30/08/24.
//

import SwiftUI

struct LogoutView: View {
    private let kTitle = "Disconnecting..."
    private let kDesc = "You've been disconnected. Tap “Cancel” to stay connected with your current wallet."
    private let kCancelButtonTitle = "CANCEL"
    
    @EnvironmentObject var mainState: MainViewModel
    
    @State var isSuccess: Bool = false
    @Binding var isLoggingOut: Bool
    
    @StateObject var viewModel: LogoutViewModel = LogoutViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                CircularProgress(isSuccess: $isSuccess)
                    .padding(.bottom, 20)
                Text(kTitle)
                    .font(FontStyle.foundersGrotesk(size: 28))
                Text(kDesc)
                    .font(FontStyle.neueMontreal(size: 16))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
            }.onAppear(perform: {
                viewModel.setMainState(state: mainState)
                viewModel.startCountdown()
            }).frame(maxWidth: .infinity)
                .background(.appCream)
            
            VStack {
                Spacer()
                
                if !viewModel.isLogoutDone {
                    UnderlineButtonView(title: "\(kCancelButtonTitle)(0:0\(viewModel.countdown))", action: {
                        viewModel.stopCountdown()
                        withAnimation {
                            isLoggingOut = false
                        }
                    })
                    .padding()
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

#Preview {
    @State var isLogginOut = true
    return LogoutView(isLoggingOut: $isLogginOut)
        .environmentObject(MainViewModel.new())
}
