//
//  HiveDashboardBottomSheetTitleSection.swift
//  Bythen
//
//  Created by Darindra R on 22/11/24.
//

import SwiftUI

struct HiveDashboardBottomSheetTitleSection: View {
    let isTrial: Bool
    let isActive: Bool

    private var title: String {
        guard !isTrial else { return "FREE TRIAL" }
        
        return isActive ? "ACTIVE" : "INACTIVE"
    }

    private var backgroundColor: Color {
        guard !isTrial else { return HiveColors.pacmanYellow }
        
        return isActive ? .appGreen : .elmoRed500
    }
    
    private var textColor: Color {
        guard !isActive else { return .byteBlack }
        
        return .white
    }

    var body: some View {
        HStack {
            Text("RANK")
                .font(FontStyle.foundersGrotesk(.semibold, size: 32))
                .foregroundStyle(.white)

            Spacer()

            Text(title)
                .font(FontStyle.dmMono(.medium, size: 14))
                .foregroundStyle(textColor)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}
