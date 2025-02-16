//
//  SideMenuView.swift
//  Bythen
//
//  Created by edisurata on 19/09/24.
//

import SwiftUI

struct SideMenuView: View {
    @Environment(\.openURL) var openURL
    @Binding var theme: ColorScheme
    @Binding var isPresented: Bool
    @Binding var selectedPage: MenuPage
    @Binding var notificationIconConfiguration: NotificationIconConfiguration
    @Binding var configuration: SideMenuConfiguration
    var infoViewModel: SideMenuInfoViewModel
    var selectMenuAction: (_ page: MenuPage) -> Void
    var logoutAction: () -> Void
    var notificationListAction: () -> Void
    
    @State private var isShowBg: Bool = false
    
    private var headerSection: some View {
        var logoColor: Color {
            switch selectedPage {
            case .studio: .gokuOrange500
            case .hive, .mission, .hiveEarnings: HiveColors.mainYellow
            default:
                ByteColors.foreground(for: theme)
            }
        }
        
        return HStack {
            Image("bythen-logo")
                .renderingMode(.template)
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundStyle(logoColor)
                .padding(.leading, 12)
            Spacer()
            if notificationIconConfiguration.showNotificationIcon {
                ZStack {
                    ZStack {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.white)
                    }
                    .overlay {
                        Circle().stroke(Color.white, lineWidth: 1)
                            .frame(width: 32, height: 32)
                    }
                }
                .frame(width: 44, height: 44)
                .overlay(alignment: .topTrailing) {
                    if notificationIconConfiguration.showRedDot {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 12, height: 12)
                                .offset(x: -2, y: 6)
                        }
                    }
                }
                .onTapGesture {
                    showHideMenu(false)
                    notificationListAction()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 42)
    }
    
    private var infoView: some View {
        Group {
            VStack(spacing: 0) {
                HStack {
                    CachedAsyncImage(urlString: infoViewModel.imageURL, delay: 0.5)
                        .foregroundStyle(ByteColors.foreground(for: theme))
                        .frame(width: 44, height: 44)
                        .background(ByteColors.foreground(for: theme).opacity(0.1))
                        .clipShape(Circle())
                    VStack {
                        Text(infoViewModel.name)
                            .font(FontStyle.neueMontreal(.medium, size: 14))
                            .foregroundStyle(ByteColors.foreground(for: theme))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(infoViewModel.walletAddress)
                            .font(FontStyle.dmMono(.regular, size: 14))
                            .foregroundStyle(ByteColors.foreground(for: theme).opacity(0.5))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.leading, 7)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    guard FeatureFlag.profilePage.isFeatureEnabled() else {
                        return
                    }
                    
                    selectMenuAction(.profile)
                    showHideMenu(false)
                }
                
                ByteColors.foreground(for: theme).opacity(0.1).frame(height: 1)
                
                Button(
                    action: {
                        showHideMenu(false)
                        logoutAction()
                    }
                ) {
                    HStack {
                        Image("logout")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(ByteColors.foreground(for: theme))
                            .frame(width: 20, height: 20)
                            .rotationEffect(.degrees(180))
                            .padding(.vertical, 16)
                        Text("LOG OUT")
                            .font(FontStyle.foundersGrotesk(.semibold, size: 16))
                            .foregroundStyle(ByteColors.foreground(for: theme))
                            .padding(.leading, 3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(ByteColors.foreground(for: theme).opacity(0.1), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            
            if FeatureFlag.sideMenuAppVersion.isFeatureEnabled() {
                Text("APP VERSION: \(infoViewModel.appVersion)")
                    .font(.foundersGrotesk(.semibold, size: 12))
                    .foregroundStyle(ByteColors.foreground(for: theme).opacity(0.3))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .padding(.bottom, 20)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                if isShowBg {
                    ByteColors.foreground(for: theme).opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            /// Close the view on background tap
                            showHideMenu(false)
                        }
                }
                
                VStack {
                    headerSection
                    
                    ScrollView {
                        sideMenuSectionContent(configuration.mainSections)
                            .padding(.horizontal, 16)
                        
                        sideMenuSectionContent(configuration.studioSections)
                            .padding(.horizontal, 16)
                        
                        sideMenuSectionContent(configuration.hiveSections)
                            .padding(.horizontal, 16)
                    }
                    
                    Spacer()
                    
                    infoView
                }
                .frame(maxWidth: geo.size.width * 0.85, maxHeight: .infinity, alignment: .top)
                .background(ByteColors.background(for: theme))
                .onAppear {
                    showHideMenu()
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -100 {
                                // Left swipe
                                showHideMenu(false)
                            }
                        }
                )
            }
        }
    }
    
    private func sideMenuSectionContent(_ sideMenuSections: [any SideMenuSection]?) -> some View {
        Group {
            if let sideMenuSections = sideMenuSections {
                let headerText = sideMenuSections.first?.header ?? ""
                
                VStack {
                    if !headerText.isTrulyEmpty {
                        Text(headerText)
                            .font(FontStyle.foundersGrotesk(.semibold, size: 16))
                            .foregroundStyle(ByteColors.foreground(for: theme).opacity(0.7))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                    }
                    
                    ForEach(sideMenuSections, id: \.detail.title) { section in
                        Button(
                            action: {
                                showHideMenu(false)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    guard let page = section.detail.page else {
                                        if let url = section.detail.url {
                                            openURL(url)
                                        }
                                        return
                                    }
                                    
                                    selectMenuAction(page)
                                }
                            }
                        ) {
                            HStack {
                                Image(section.detail.iconName)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(ByteColors.foreground(for: theme))
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                Text(section.detail.title)
                                    .font(FontStyle.neueMontreal(.medium, size: 18))
                                    .foregroundStyle(ByteColors.foreground(for: theme))
                                    .frame(height: 24)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedPage == section.detail.page ? ByteColors.foreground(for: theme).opacity(0.05) : .clear)
                            )
                        }
                    }
                    
                    if headerText != "HIVE" {
                        ByteColors.foreground(for: theme).opacity(0.2)
                            .frame(height: 1)
                            .padding(16)
                    }
                }
            }
        }
    }
    
    private func showHideMenu(_ isPresented: Bool = true, animationDuration: TimeInterval = 0.5) {
        withAnimation(.easeInOut(duration: animationDuration)) {
            isShowBg = isPresented
            self.isPresented = isPresented
        }
    }
}

#Preview {
    SideMenuView(
        theme: .constant(.light),
        isPresented: .constant(true),
        selectedPage: .constant(.empty),
        notificationIconConfiguration: .constant(NotificationIconConfiguration(showNotificationIcon: true, showRedDot: true)),
        configuration: .constant(
            SideMenuConfiguration(mainSections: SideMenuMainSection.allCases, studioSections: SideMenuStudioSection.allCases, hiveSections: SideMenuHiveSection.allCases)
        ),
        infoViewModel: SideMenuInfoViewModel(
            name: "User Name",
            imageURL: "https://assets.bythen.ai/general/profile-1.png",
            walletAddress: "0x77ae...974",
            appVersion: "1.0.0 (2)"
        ),
        selectMenuAction: { _ in },
        logoutAction: {},
        notificationListAction: {}
    )
}
