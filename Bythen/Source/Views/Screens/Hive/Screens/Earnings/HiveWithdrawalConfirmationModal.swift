//
//  HiveWithdrawalConfirmationModal.swift
//  Bythen
//
//  Created by Ega Setya on 31/01/25.
//

import SwiftUI
import MarkdownUI

struct HiveWithdrawalConfirmationModal: View {
    @Binding var viewModel: HiveWithdrawalConfirmationViewModel
    var didTapClose: (() -> Void)?
    var withdrawTapped: (() -> Void)?
    
    @State private var shouldDisableWithdrawButton: Bool = true
    @State private var shouldShowWithdrawLoading: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                BasicCircularButton(image: "white-close") {
                    didTapClose?()
                }
                .foregroundColor(.white)
                .backgroundColor(.ghostWhite200)
            }
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 0) {
                    Color(.white)
                        .frame(height: 5)
                    
                    createMainText()
                    
                    createPricingText(title: "ESTIMATED GAS FEE", ethText: viewModel.gasFeeEthText, usdText: viewModel.gasFeeUSDText)
                        .padding(.top, 20)
                    
                    Color(.white)
                        .frame(height: 5)
                        .padding(.top, 16)
                    
                    createPricingText(title: "YOU’LL RECEIVE", ethText: viewModel.receivedEthText, usdText: viewModel.receivedUSDText)
                        .padding(.top, 29)
                    
                    createRulesList()
                    
                    HStack(alignment: .center, spacing: 0) {
                        Image(shouldDisableWithdrawButton ? "check-box-blank" : "check-chevron")
                            .resizable()
                            .renderingMode(.template)
                            .frame(square: 12)
                            .foregroundStyle(shouldDisableWithdrawButton ? .white : .black)
                            .background(
                                Rectangle().fill(shouldDisableWithdrawButton ? .clear : HiveColors.mainYellow)
                            )
                            .padding(.trailing, 8)
                        
                        Group {
                            Text("I accept and agree to Bytes Hive's ")
                            Text("Term of Use")
                                .opacity(0.8)
                        }
                        .font(.neueMontreal(size: 12))
                    }
                    .padding(.top, 53)
                    .onTapGesture {
                        shouldDisableWithdrawButton.toggle()
                    }
                    
                    if shouldShowWithdrawLoading {
                        NetworkProgressView(size: 30)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 48)
                            .padding(.top, 12)
                    } else {
                        CommonButton.textIcon(.left(name: "withdraw"), title: "WITHDRAW", font: .foundersGrotesk(.semibold, size: 16), fillWidth: true, enabledBackgroundColor: HiveColors.mainYellow, isDisabled: $shouldDisableWithdrawButton) {
                            withdrawTapped?()
                            
                            shouldShowWithdrawLoading = true
                        }
                        .frame(height: 48)
                        .padding(.top, 16)
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(24)
            }
            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.6)
            .background(
                Color(.ghostWhite200)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.black)
                            .padding(.top, 3)
                    }
            )
            .cornerRadius(8, corners: [.topLeft, .topRight])
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.black).opacity(0.9))
    }
    
    private func createMainText() -> some View {
        Group {
            Text("YOU’LL WITHDRAW")
                .font(.foundersGrotesk(.semibold, size: 16))
                .padding(.top, 16)
            
            Text(viewModel.honeyText)
                .font(.foundersGrotesk(.semibold, size: 40))
                .padding(.top, 8)
            
            HStack(alignment: .bottom, spacing: 8) {
                Text(viewModel.ethText)
                    .font(.dmMono(size: 12))
                
                Text(viewModel.usdText)
                    .font(.dmMono(size: 12))
                    .foregroundStyle(.ghostWhite500)
            }
            .padding(.top, 8)
        }
    }
    
    private func createPricingText(title: String, ethText: String, usdText: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.foundersGrotesk(.semibold, size: 14))
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(ethText)
                    .font(.dmMono(size: 16))
                    .minimumScaleFactor(0.75)
                
                Text(usdText)
                    .font(.dmMono(size: 12))
                    .foregroundStyle(.ghostWhite500)
            }
        }
    }
    
    private func createRulesList() -> some View {
        return Group {
            Text("WITHDRAWAWAL RULES")
                .font(.foundersGrotesk(.semibold, size: 16))
                .padding(.top, 16)
            
            Markdown(
                StringRepository.hiveWithdrawalRules.getString()
            )
            .markdownTextStyle(\.strong) {
                FontSize(12)
                FontWeight(.black)
                ForegroundColor(.appCream)
            }
            .markdownTextStyle {
                FontSize(12)
                FontWeight(.regular)
                ForegroundColor(.appCream)
            }
            .font(.neueMontreal(size: 12))
            .padding(.top, 12)
        }
    }
}
