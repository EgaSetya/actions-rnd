//
//  SideMenuButton.swift
//  Bythen
//
//  Created by edisurata on 13/09/24.
//

import SwiftUI

struct SideMenuButton: View {
    @EnvironmentObject var sideMenu: SideMenuContentViewModel
    @Environment(\.colorScheme) var theme
    @State var sideMenuTheme: ColorScheme = .light

    var body: some View {
        Button(
            action: {
                hideKeyboard()
                withAnimation(.easeInOut(duration: 0.5)) {
                    sideMenu.showSideMenu(true, isDarkMode: sideMenuTheme == .dark)
                }
            },
            label: {
                Image("bars-sort.sharp.solid")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(ByteColors.foreground(for: theme))
                    .padding(10)
            }
        )
    }
}

#Preview {
    VStack {
        HStack {
            SideMenuButton()
            Spacer()
        }
    }
    .background(.green)
    .environmentObject(MainViewModel.new())
}
