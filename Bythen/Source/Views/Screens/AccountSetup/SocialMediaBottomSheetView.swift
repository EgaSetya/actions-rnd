//
//  SocialMediaBottomSheetView.swift
//  Bythen
//
//  Created by erlina ng on 10/12/24.
//

import SwiftUI

struct SocialMediaBottomSheetView: View {
    @EnvironmentObject var viewModel: AccountSetupContentViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("How to Reach You")
                .font(Font.neueMontreal(.medium, size: 24))
                .foregroundStyle(Color.byteBlack)
                .padding(.leading, 16)
            
            ForEach(Array(SocialMedia.allCases.enumerated()), id: \.element.rawValue) { index, socialMedia in
                VStack {
                    SocialMediaBottomSheetViewCell(
                        value: socialMedia,
                        selectedValue: $viewModel.selectedSocialMedia
                    )
                    .background()
                    .onTapGesture {
                        viewModel.selectedSocialMedia = socialMedia
                        dismiss()
                    }
                }
            }
            .padding(.horizontal, 24)
            Spacer()
        }
        .padding(.top, 24)
        .background(Color.white)
    }
    
    var spacerView: some View {
        GeometryReader { geometry in
            Rectangle()
                .frame(width: geometry.size.width, height: 1)
                .foregroundColor(Color.byteBlack400)
        }
    }
}

#Preview {
    SocialMediaBottomSheetView()
        .environmentObject(AccountSetupContentViewModel.new())
}
