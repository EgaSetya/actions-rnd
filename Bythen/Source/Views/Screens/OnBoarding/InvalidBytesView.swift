//
//  InvalidBytesView.swift
//  Bythen
//
//  Created by edisurata on 30/08/24.
//

import SwiftUI

struct InvalidBytesView: View {
    private let kCoverImageName = "invalid-byte-cover"
    
    private let kTitle = "Sorry, we couldn't\ndetect a bythen Pod in\nyour wallet.".uppercased()
    
    private let kDesc = "Use a wallet that holds a supported Original NFT and the corresponding Bythen Pod. If your Original NFT is stored in a cold wallet, delegate it via "
    private let delegateXyzLink = "Delegate.xyz."
    
    private let kTryDemoButtonTitle = "REDIRECT TO DEMO"
    private let kLogoutButtonTitle = "TRY ANOTHER WALLET"
    
    @State var isLoggingOut = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image(kCoverImageName)
                    .resizable()
                    .scaledToFit()
                
                Text(kTitle)
                    .font(FontStyle.foundersGrotesk(.semibold, size: 32))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(0)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                
                Group {
                    Text(kDesc)  + Text(delegateXyzLink).underline()
                }
                .font(FontStyle.neueMontreal(.regular, size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isLoggingOut = true
                    }
                }, label: {
                    HStack {
                        Image("wallet")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.white)
                            .frame(width: 16 , height: 16)
                        
                        Text("TRY ANOTHER WALLET")
                            .font(.foundersGrotesk(.semibold, size: 20))
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(.byteBlack)
                })
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                Spacer()
            }
            .background(.white)
            .ignoresSafeArea()
            
//            VStack {
//                Text("Exclusive for Pudgy Penguins or BAYC NFT owners, access our limited time free trial until 15 December.")
//                    .font(.neueMontreal(size: 12))
//                    .padding(.vertical, 12)
//                    .padding(.horizontal, 20)
//                    .background(.white)
//                    .border(.byteBlack.opacity(0.2), width: 1)
//                Spacer()
//            }
//            .padding(.horizontal, 8)
//            .padding(.top, 8)
            
            if isLoggingOut {
                LogoutView(isLoggingOut: $isLoggingOut)
                .zIndex(1)
                .transition(.move(edge: .bottom))
            }
        }
    }
}

#Preview {
    InvalidBytesView()
}
