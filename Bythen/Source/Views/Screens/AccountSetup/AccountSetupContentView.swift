//
//  AccountSetupContentView.swift
//  Bythen
//
//  Created by erlina ng on 13/11/24.
//

import SwiftUI

struct AccountSetupContentView: View {
    @EnvironmentObject var mainState: MainViewModel
    @StateObject var viewModel: AccountSetupContentViewModel
    @State var isShowBottomSheet: Bool = false
    @State var isSocialMediaBottomSheet: Bool = false
    
    var didSuccessSaveAccountSetup: (String) -> Void = { _ in }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Spacer()
                        Button(action: {
                            mainState.sidemenuContentVM?.logout()
                        }, label: {
                            Image("close")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.byteBlack)
                                .padding(16)
                        })
                    }
                    
                    title
                    
                    input
                    
                    Button {
                        viewModel.submitSetupAccount(
                            onComplete: { didSuccessSaveAccountSetup(viewModel.nicknameTextfield) }
                        )
                    } label: {
                        Text("CONFIRM")
                            .font(.foundersGrotesk(.semibold, size: 16))
                            .foregroundStyle(viewModel.isFilled ? .white : .byteBlack.opacity(0.4))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .background(Rectangle().fill(viewModel.isFilled ? .byteBlack : .byteBlack.opacity(0.1)))
                    .disabled(!viewModel.isFilled)
                    .padding(28)
                    
                }
                .background(.white)
                .padding(.horizontal, 28)
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
                .sheet(isPresented: $isShowBottomSheet) {
                    UserInterestBottomSheetView()
                        .environmentObject(viewModel)
                        .presentationDetents([.height(300), .large])
                }
                .sheet(isPresented: $isSocialMediaBottomSheet) {
                    SocialMediaBottomSheetView()
                        .environmentObject(viewModel)
                        .presentationDetents([.height(200), .large])
                }
            }
        }
        .onAppear {
            viewModel.setMainState(state: mainState)
        }
    }
    
    var title: some View {
        VStack(alignment: .leading) {
            Text("Claim your Nickname Now!")
                .font(.foundersGrotesk(.medium, size: 28))
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
                .padding(.top, 28)
                .padding(.bottom, 12)
            
            Text("Enter your email and social platform account to claim your nickname and complete your account setup.")
                .font(.neueMontreal(.regular, size: 14))
                .lineSpacing(6)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 28)
        }
        .padding(.horizontal, 28)
    }
    
    var input: some View {
        VStack(spacing: 18) {
            nickname
            email
            socialMedia
            interest
        }
        .padding(.horizontal, 28)
    }
    
    var nickname: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nickname")
                .font(FontStyle.dmMono(.medium, size: 14))
            
            HStack {
                TextField("Enter nickname", text: $viewModel.nicknameTextfield)
                    .font(FontStyle.neueMontreal(size: 14))
                    .foregroundStyle(.appBlack)
                    .onChange(of: viewModel.nicknameTextfield, perform: { newValue in
                        self.viewModel.restrictNameInput()
                        if viewModel.showNicknameError {
                            viewModel.showNicknameError = false
                        }
                        if newValue.count > 15 {
                            self.viewModel.setNameLimit(newValue: newValue)
                       }
                    })
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .border(viewModel.showNicknameError ? Color.elmoRed500 : Color.byteBlack400, width: 1)

            if viewModel.nicknameTextfield.count >= 1, !viewModel.showNicknameError {
                Text("\(viewModel.nicknameTextfield.count)/15")
                    .font(FontStyle.neueMontreal(.regular, size: 12))
                    .foregroundStyle(Color.byteBlack600)
                    .multilineTextAlignment(.leading)
            }
            
            if viewModel.showNicknameError {
                HStack {
                    Image(systemName: "info.circle")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.elmoRed500)
                        .scaledToFit()
                        .frame(height: 12)
                    
                    Text($viewModel.nicknameErrorMessage.wrappedValue)
                        .font(FontStyle.neueMontreal(.regular, size: 12))
                        .foregroundStyle(Color.elmoRed500)
                        .multilineTextAlignment(.leading)
                }

            } else {
                Text("You will not be able to change your nickname later.")
                    .font(FontStyle.neueMontreal(.regular, size: 12))
                    .foregroundStyle(Color.byteBlack600)
                    .multilineTextAlignment(.leading)
            }
        }
    }
    
    var email: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email")
                .font(FontStyle.dmMono(.medium, size: 14))
            
            HStack {
                TextField("Enter email address", text: $viewModel.emailTextfield)
                    .font(FontStyle.neueMontreal(size: 14))
                    .foregroundStyle(.appBlack)
                    .onChange(of: viewModel.emailTextfield, perform: { newValue in
                        if viewModel.showEmailError {
                            viewModel.showEmailError = false
                        }
                    })
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .border(viewModel.showEmailError ? Color.elmoRed500 : Color.byteBlack400, width: 1)
            
            if viewModel.showEmailError {
                HStack {
                    Image(systemName: "info.circle")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.elmoRed500)
                        .scaledToFit()
                        .frame(height: 12)
                    
                    Text($viewModel.emailErrorMessage.wrappedValue)
                        .font(FontStyle.neueMontreal(.regular, size: 12))
                        .foregroundStyle(Color.elmoRed500)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
    
    var socialMedia: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How to Reach You")
                .font(FontStyle.dmMono(.medium, size: 14))
            
            HStack {
                Button {
                    isSocialMediaBottomSheet = true
                } label: {
                    HStack {
                        Text(viewModel.selectedSocialMediaTitle)
                            .font(.neueMontreal(.medium, size: 14))
                            .foregroundStyle(.byteBlack)
                        
                        Image(systemName: "chevron.down")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.byteBlack)
                            .scaledToFit()
                            .frame(height: 5)
                    }
                    
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .border(Color.byteBlack400, width: 1)
                
                TextField("Username", text: $viewModel.socialMediaTextfield)
                    .font(FontStyle.neueMontreal(size: 14))
                    .foregroundStyle(.appBlack)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .frame(height: 36)
                    .border(Color.byteBlack400, width: 1)
            }
            
            Text("Your preferred platform for our success team to contact you.")
                .font(FontStyle.neueMontreal(.regular, size: 12))
                .foregroundStyle(Color.byteBlack600)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    var interest: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How Would You Describe Yourself")
                .font(FontStyle.dmMono(.medium, size: 14))
            
            Button {
                isSocialMediaBottomSheet = false
                isShowBottomSheet = true
            } label: {
                HStack {
                    Text(viewModel.selectedUserInterest != .none ? viewModel.selectedUserInterest.rawValue : "Choose one")
                        .font(Font.neueMontreal(.regular, size: 14))
                        .foregroundStyle(viewModel.selectedUserInterest != .none ? Color.byteBlack : Color.byteBlack400 )
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.byteBlack)
                        .scaledToFit()
                        .frame(height: 5)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .border(Color.byteBlack400, width: 1)
        }
    }
}

#Preview {
    AccountSetupContentView(viewModel: AccountSetupContentViewModel.new())
        .environmentObject(MainViewModel.new())
}
