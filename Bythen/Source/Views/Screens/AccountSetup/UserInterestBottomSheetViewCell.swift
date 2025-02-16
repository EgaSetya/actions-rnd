//
//  UserInterestBottomSheetViewCell.swift
//  Bythen
//
//  Created by erlina ng on 05/12/24.
//

import SwiftUI

struct UserInterestBottomSheetViewCell: View {
    @State var name: String
    @Binding var selectedValue: UserInterest
    var isSelected: Bool {
        return selectedValue.rawValue == name
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text(name)
                .font(Font.neueMontreal(.regular, size: 16))
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
        .padding(.vertical, 16)
    }
}
