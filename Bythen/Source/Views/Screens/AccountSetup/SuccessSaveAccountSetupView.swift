//
//  SuccessSaveAccountSetupView.swift
//  Bythen
//
//  Created by erlina ng on 05/12/24.
//

import SwiftUI


struct SuccessSaveAccountSetupView: View {
    var didTapClose: () -> Void = {}
    var nickname: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Spacer()
                Image("close")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .onTapGesture {
                        didTapClose()
                    }
            }
            .padding(18.5)
            
            Image("upload-success-check")
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 52)
            
            Text("Account Setup Success")
                .font(.foundersGrotesk(.medium, size: 28))
                .lineSpacing(4)
                .multilineTextAlignment(.center)
                .padding(.vertical, 12)
            
            Text("Congratulations \(nickname), your nickname has been successfully claimed.")
                .font(.neueMontreal(.regular, size: 14))
                .lineSpacing(6)
                .multilineTextAlignment(.center)
            
            Button {
                didTapClose()
            } label: {
                Text("DONE")
                    .font(.foundersGrotesk(.semibold, size: 16))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .background(Rectangle().fill(.byteBlack))
            .padding(28)
        }
        .background(.white)
        .padding(.horizontal, 16)
    }
}
