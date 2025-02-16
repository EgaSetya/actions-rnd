//
//  AvatarNavigationView.swift
//  Bythen
//
//  Created by edisurata on 04/10/24.
//

import SwiftUI

struct AvatarNavigationView<Destination>: View where Destination : View {
    @Binding var byteName: String
    @Binding var isTapActive: Bool
    var navigateDojoView: Destination
    
    var body: some View {
        HStack {
            SideMenuButton()
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
                .colorScheme(.dark)
            
            Button(
                action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isTapActive = true
                    }
                }
            ) {
                Text(byteName.uppercased())
                    .font(FontStyle.foundersGrotesk(.semibold, size: 18))
                    .foregroundStyle(.white)
                Image("chevron-down-white")
                    .resizable()
                    .rotationEffect(.degrees(isTapActive ? 0 : 180))
                    .tint(.white)
                    .frame(width: 16, height: 16)
            }
            .frame(maxWidth: .infinity)
            NavigationLink(destination: navigateDojoView) {
                HStack {
                    Image("account-balance.fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.byteBlack)
                        .frame(width: 20, height: 20)
                        .padding(11)
                }
                .background(.white)
                .clipShape(Circle())
                .background(
                    Circle()
                        .stroke(.appBlack, lineWidth: 1)
                )
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .leading)
    }
}

#Preview {
    @State var isActive: Bool = false
    @State var title: String = "Hello World"
    VStack {
        AvatarNavigationView(byteName: $title, isTapActive: $isActive, navigateDojoView: DojoView(viewModel: DojoViewModel.new(byteBuild: ByteBuild())))
    }.background(.green)
}
