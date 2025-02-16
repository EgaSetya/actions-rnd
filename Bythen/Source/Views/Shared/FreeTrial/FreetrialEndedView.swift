//
//  FreetrialEndedView.swift
//  Bythen
//
//  Created by edisurata on 06/11/24.
//

import SwiftUI

struct FreetrialEndedView: View {
    private let contentTitle = "Free Trial Ended"
    private let contentText = "Your free trial has ended. To continue using our services, please purchase your pod now."

    @Binding var tokenSymbol: String
    
    var closeButtonAction: () -> Void = { }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                ZStack(alignment: .topTrailing) {
                    Image("trial-cover")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .clipped()
                    HStack {
                        Spacer()
                        Button {
                            closeButtonAction()
                        } label: {
                            Image("close")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 12, height: 13)
                                .foregroundStyle(.white)
                                .padding(22)
                            
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Text(contentTitle.uppercased())
                    .font(.foundersGrotesk(.medium, size: 28))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 32)
                    .padding(.top, 24)
                
                Text(contentText)
                    .font(.neueMontreal(size: 14))
                    .padding(.top, 8)
                    .padding(.horizontal, 32)
                    .multilineTextAlignment(.center)
                
                Button {
                    openStore()
                } label: {
                    Text("Buy Now".uppercased())
                        .font(.foundersGrotesk(.semibold, size: 16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .background(Rectangle().fill(.byteBlack))
                .padding(.horizontal, 32)
                .padding(.top, 32)
                .padding(.bottom, 16)
               
            }
            .background(.white)
            .padding(.horizontal, 20)
            
            
        }
    }
    
    func openStore() {
        if let url = URL(string: "\(AppConfig.storeUrl)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    FreetrialEndedView(tokenSymbol: .constant("pudgy"))
}
