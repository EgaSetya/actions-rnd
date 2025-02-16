//
//  SocialMediaBottomSheetViewCell.swift
//  Bythen
//
//  Created by erlina ng on 10/12/24.
//


import SwiftUI

struct SocialMediaBottomSheetViewCell: View {
    //MARK: - Properties
    @State var value: SocialMedia
    
    var valueName: String {
        switch value {
//        case .discord: "Discord"
        case .telegram: "Telegram"
        case .twitter: "Twitter"
        }
    }
    
    var valueImage: String {
        switch value {
//        case .discord: "discord-icon"
        case .telegram: "telegram-icon"
        case .twitter: "twitter-icon"
        }
    }
    
    var isSelected: Bool {
        return selectedValue == value
    }
    
    @Binding var selectedValue: SocialMedia
    
    var body: some View {
        HStack(alignment: .center) {
            Image(valueImage)
                .resizable()
                .scaledToFit()
                .frame(height: 24)
            
            Text(valueName)
                .font(Font.neueMontreal(.regular, size: 20))
                .foregroundStyle(Color.byteBlack)
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.byteBlack)
                    .scaledToFit()
                    .frame(height: 12)
            }
        }
        .padding(.vertical, 8)
    }
}
