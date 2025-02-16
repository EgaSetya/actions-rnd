//
//  LoginEmailView.swift
//  Bythen
//
//  Created by edisurata on 17/10/24.
//

import SwiftUI

struct LoginEmailView: View {
    let kConnectEmailTitle: String = "Connect Email"
    
    @StateObject var viewModel: LoginEmailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text(kConnectEmailTitle)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(FontStyle.foundersGrotesk(.medium, size: 28))
                .foregroundStyle(.appBlack)
                
            TextField("Continue with email", text: $viewModel.email)
                .font(FontStyle.neueMontreal(size: 18))
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(
                    Rectangle()
                        .stroke(.appBlack, lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .textInputAutocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureField("Password", text: $viewModel.password)
                .font(FontStyle.neueMontreal(size: 18))
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(
                    Rectangle()
                        .stroke(.appBlack, lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .textInputAutocapitalization(.none)
                .disableAutocorrection(true)
            
            Button {
                viewModel.loginWithEmail()
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .font(FontStyle.foundersGrotesk(.semibold, size: 18))
                    .foregroundStyle(.white)
                    .padding(16)
                    .background(viewModel.isEnableLogin ? .appBlack : .appBlack.opacity(0.1))
            }
            .padding(16)
            .disabled(!viewModel.isEnableLogin)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.totoroGrey100)
    }
}

#Preview {
    LoginEmailView(viewModel: LoginEmailViewModel.new())
}
