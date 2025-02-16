//
//  NavigationBar.swift
//  Bythen
//
//  Created by Ega Setya on 23/01/25.
//

import SwiftUI

enum NavigationBarType {
    case `default`
    case hive
}

struct NavigationBarModifier: ViewModifier {
    @EnvironmentObject
    var sideMenuState: SideMenuContentViewModel
    var type: NavigationBarType = .default
    
    private var sideMenu: some View {
        let colorScheme: ColorScheme = type == .default ? .light : .dark
        
        return SideMenuButton(sideMenuTheme: colorScheme).colorScheme(colorScheme)
    }
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            HStack {
                sideMenu
                    .padding(.leading, 8)
                
                Spacer()
                
                if type == .hive {
                    Image("bytestudio-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 29)
                        .padding(.trailing, 20)
                }
            }
            .padding(.top, 60)
            .padding(.bottom, 12)
            .background(.byteBlack)
            
            // Content
            content
        }
        .edgesIgnoringSafeArea(.top)
    }
}

extension View {
    func embedNavigationBar() -> some View {
        self.modifier(NavigationBarModifier())
    }
    
    func embedHiveNavigationBar() -> some View {
        self.modifier(NavigationBarModifier(type: .hive))
    }
}
