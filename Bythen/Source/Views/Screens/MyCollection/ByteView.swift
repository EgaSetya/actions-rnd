//
//  ByteView.swift
//  Bythen
//
//  Created by edisurata on 01/09/24.
//

import SwiftUI

struct ByteBannerView: View {
    
    @State var text: String
    var closeAction: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 0) {
            Image("info.fill")
                .resizable()
                .renderingMode(.template)
                .frame(width: 20, height: 20)
                .foregroundStyle(.byteBlack)
                .padding(12)
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.byteBlack)
                .font(FontStyle.neueMontreal(size: 12))
                .lineSpacing(4)
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
            
            Color.byteBlack.opacity(0.1)
                .frame(maxWidth: 1)
                .padding(.vertical, 8)
            
            Button {
                if let closeAction = closeAction {
                    closeAction()
                }
            } label: {
                Image("close")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 11, height: 11)
                    .foregroundStyle(.byteBlack)
                    .padding(24)
            }

        }
        .frame(maxWidth: .infinity, maxHeight: 80)
        .background(.gokuOrange100)
        .padding(.top, 16)
    }
}

struct ByteView: View {
    @Environment(\.colorScheme) var theme
    @Binding var isOriginalNftValid: Bool
    @Binding var isBythenPodValid: Bool
    @Binding var isPrimary: Bool
    @Binding var isTrial: Bool
    @Binding var byteName: String
    @Binding var showAssetNotReadyBanner: Bool
    @Binding var showTrialCountdown: Bool
    @Binding var countdown: Int64
    @Binding var showOriginalNftInvalidBanner: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    HStack(spacing: 0) {
                        if isPrimary {
                            Image("star")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 10, height: 10)
                                .foregroundStyle(ByteColors.foreground(for: theme))
                                .padding(.leading, 6)
                            
                            Text("PRIMARY")
                                .font(FontStyle.neueMontreal(size: 8))
                                .foregroundColor(ByteColors.foreground(for: theme))
                                .padding(.leading, 3)
                                .padding(.trailing, 6)
                                .padding(.vertical, 3)
                                
                        } else if isTrial {
                            Image("timer.fill")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 10, height: 10)
                                .foregroundStyle(ByteColors.foreground(for: theme))
                                .padding(.leading, 6)
                            
                            Text("TRIAL")
                                .font(FontStyle.neueMontreal(size: 8))
                                .foregroundColor(ByteColors.foreground(for: theme))
                                .padding(.leading, 3)
                                .padding(.trailing, 6)
                                .padding(.vertical, 3)
                        } else {
                            Text("OWNED")
                                .font(FontStyle.neueMontreal(size: 8))
                                .foregroundColor(ByteColors.foreground(for: theme))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                        }
                    }
                    .background(.white.opacity(0.3))
                    .cornerRadius(8)
                }.frame(maxWidth: .infinity, alignment: .leading)
                
                Text(byteName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(FontStyle.foundersGrotesk(.semibold, size:44))
                    .foregroundColor(ByteColors.foreground(for: theme))
                
                if showTrialCountdown {
                    HStack(spacing: 0) {
                        Text("Free trial ends \(formatCountdown())")
                            .font(.dmMono(.medium, size: 11))
                            .foregroundStyle(ByteColors.foreground(for: theme))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 10)
                    }
                    .background(Rectangle().fill(ByteColors.foreground(for: theme).opacity(0.1), strokeBorder: ByteColors.foreground(for: theme), lineWidth: 1))
                    .padding(.top, 16)
                }
                Spacer()
                
                Text("STATUS")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                    .font(FontStyle.dmMono(size: 11))
                    .foregroundStyle(ByteColors.foreground(for: theme))
                    .opacity(0.5)
                
                ZStack {
                    Rectangle()
                        .background(.ultraThinMaterial)
                        .opacity(0.8)
                        .blur(radius: 20, opaque: true)
                    
                    HStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text("original_NFT")
                                .font(FontStyle.dmMono(.medium, size: 12))
                                .foregroundColor(ByteColors.foreground(for: theme))
                            Spacer()
                            VStack {
                                Text(isOriginalNftValid ? "Valid" : "Invalid")
                                    .font(FontStyle.dmMono(.medium, size: 11))
                                    .foregroundColor(.black)
                                    .padding([.leading, .trailing], 5)
                                    .padding([.top, .bottom], 2)
                            }.background(isOriginalNftValid ? .appGreen : .appRed)
                        }
                        .padding(.horizontal, 12)
                        
                        HStack(spacing: 0) {
                            Text("bythen_pod")
                                .font(FontStyle.dmMono(.medium, size: 12))
                                .foregroundColor(ByteColors.foreground(for: theme))
                             
                            Spacer()
                             
                            VStack {
                                Text(isBythenPodValid ? "Valid" : "Invalid")
                                    .font(FontStyle.dmMono(.medium, size: 11))
                                    .foregroundColor(.black)
                                    .padding([.leading, .trailing], 5)
                                    .padding([.top, .bottom], 2)
                            }.background(isBythenPodValid ? .appGreen : .appRed)
                        }
                        .padding(.horizontal, 12)
                    }
                }.frame(height: 40)
                if showOriginalNftInvalidBanner {
                    ByteBannerView(text: "Original NFT not found in your wallet. Delegate it via delegate.xyz, or use our default Byte.", closeAction: {
                        showOriginalNftInvalidBanner = false
                    })
                } else if showAssetNotReadyBanner {
                    ByteBannerView(text: "Your byte will be ready in a matter of days. Once it’s complete, we’ll notify you. Meanwhile, feel free to use our default Byte.", closeAction: {
                        showAssetNotReadyBanner = false
                    })
                }
            }.background(.clear)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 200)
        }.background(.clear)
    }
    
    func formatCountdown() -> String {
        let days = countdown / (24 * 3600)
        let hours = (countdown % (24 * 3600)) / 3600
        let minutes = (countdown % 3600) / 60
        
        if days > 0 {
            return String(format: "%dD:%02dH:%02dM", days, hours, minutes)
        } else {
            let seconds = countdown % 60
            return String(format: "%02dH:%02dM:%02dS", hours, minutes, seconds)
        }
        
    }
}

#Preview {
    VStack {
        ByteView(isOriginalNftValid: .constant(true), isBythenPodValid: .constant(false), isPrimary: .constant(true), isTrial: .constant(true), byteName: .constant("MATEO"), showAssetNotReadyBanner: .constant(false), showTrialCountdown: .constant(true), countdown: .constant(604769), showOriginalNftInvalidBanner: .constant(true))
            .frame(maxHeight: .infinity)
    }
    .background(.green)
}
