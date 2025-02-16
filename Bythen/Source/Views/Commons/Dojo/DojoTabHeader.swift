//
//  DojoTabHeader.swift
//  Bythen
//
//  Created by edisurata on 11/10/24.
//

import SwiftUI

struct DojoTabHeader: View {
    @Environment(\.colorScheme) var theme
    
    private let titles = [
        "CHARACTERS",
        "DIALOGUE",
        "VOICE",
        "MEMORIES",
        "SETTINGS"
    ]
    private let icons = [
        "hand-holding-heart",
        "message-captions",
        "waveform-lines",
        "brain-circuit",
        "head-side-gear"
    ]
    
    @Binding var selectedTab: DojoTab
    @Binding var isStudioMode: Bool
    @State var showBetaBanner: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            if showBetaBanner {
                HStack(spacing: 0) {
                    Image("gift.solid")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 14, height: 14)
                        .foregroundStyle(.sonicBlue700)
                        .padding(17)
                    
                    (Text("Welcome to Dojo Beta!")
                        .font(.neueMontreal(.medium, size: 12))
                        .foregroundColor(.byteBlack) + Text(" Exciting new features are on the way.")
                        .font(.neueMontreal(size: 12))
                        .foregroundColor(.byteBlack)
                    ).padding(.trailing, 12)
                    
                    Button {
                        showBetaBanner = false
                    } label: {
                        Image("close")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.byteBlack)
                            .frame(width: 12, height: 12)
                            .padding(18)
                    }
                }
                .background(.sonicBlue100)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 16)
            }
            
            HStack(spacing: 0) {
                ForEach(DojoTab.allCases, id:\.self) { dojoTab in
                    Button(action: {
                        selectedTab = dojoTab
                    }, label: {
                        VStack(spacing: 0) {
                            Image(getIconName(dojoTab))
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(isTabSelected(dojoTab) ? .gokuOrange600 : isTabDisabled(dojoTab) ? ByteColors.foreground(for: theme).opacity(0.3) : ByteColors.foreground(for: theme))
                                .padding(6)
                                .padding(.top, 8)
                            Text(titles[dojoTab.rawValue])
                                .font(FontStyle.foundersGrotesk(.semibold, size: 11))
                                .foregroundStyle(isTabSelected(dojoTab) ? .gokuOrange600 : isTabDisabled(dojoTab) ? ByteColors.foreground(for: theme).opacity(0.3) : ByteColors.foreground(for: theme))
                                .padding(.top, 4)
                                .padding(.bottom, 12)
                        }
                        .frame(maxWidth: .infinity)
                    })
                    .disabled(isStudioMode && dojoTab != .voice)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 64)
            .padding(.horizontal, 16)
            Color.appBlack.opacity(0.1)
                .frame(maxWidth: .infinity, maxHeight: 1)
        }
        .background(ByteColors.background(for: theme))

    }
    
    func isTabSelected(_ tab: DojoTab) -> Bool {
        return selectedTab == tab
    }
    
    func getIconName(_ tab: DojoTab) -> String {
        let iconName = icons[tab.rawValue]
        if selectedTab == tab {
            return iconName + ".sharp.solid"
        } else {
            return iconName + ".sharp.light"
        }
    }
    
    func isTabDisabled(_ tab: DojoTab) -> Bool {
        return isStudioMode && tab != .voice
    }
}

#Preview {
    DojoTabHeader(selectedTab: .constant(.background), isStudioMode: .constant(false))
}
