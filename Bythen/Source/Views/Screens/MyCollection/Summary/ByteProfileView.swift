//
//  ByteProfileView.swift
//  Bythen
//
//  Created by edisurata on 03/09/24.
//

import SwiftUI

struct ByteProfileTopView: View {
    @Environment(\.colorScheme) var theme
    
    var title: String
    @Binding var value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: 16, alignment: .leading)
                .font(FontStyle.dmMono(size: 12))
                .foregroundStyle(ByteColors.foreground(for: theme).opacity(0.5))
                .padding([.leading, .trailing], 16)
                .padding([.top], 10)
            Text(value)
                .frame(maxWidth: .infinity, maxHeight: 16, alignment: .leading)
                .padding([.leading, .trailing], 16)
                .padding([.bottom], 10)
                .font(FontStyle.neueMontreal(size: 12))
                .foregroundStyle(ByteColors.foreground(for: theme))
        }
        .background(ByteColors.foreground(for: theme).opacity(0.1))
    }
}

struct ByteProfileBottomView: View {
    @Environment(\.colorScheme) var theme
    
    var iconName: String = AppImages.kXpInfo
    var title: String
    @Binding var value: String
    
    var body: some View {
        HStack(spacing: 5) {
            Image(iconName)
                .padding([.top, .leading, .bottom], 10)
                .foregroundStyle(ByteColors.foreground(for: theme))
            
            VStack(spacing: 2) {
                Text(value)
                    .frame(maxWidth: .infinity, maxHeight: 12, alignment: .leading)
                    .font(FontStyle.dmMono(size: 11))
                    .foregroundStyle(ByteColors.foreground(for: theme).opacity(0.5))
                    .padding([.trailing], 20)
                    .padding([.top], 8)
                Text(title)
                    .frame(maxWidth: .infinity, maxHeight: 12, alignment: .leading)
                    .font(FontStyle.dmMono(size: 11))
                    .foregroundStyle(ByteColors.foreground(for: theme).opacity(0.5))
                    .padding([.trailing], 20)
                    .padding([.bottom], 8)
            }
        }
        .background(ByteColors.foreground(for: theme).opacity(0.1))
    }
}

struct ByteProfileView: View {
    
    @Binding var profileInfo: String
    @Binding var role: String
    @Binding var xp: String
    @Binding var memories: String
    @Binding var knowledge: String
    
    private let kProfileInfoTitle = "Profile"
    private let kRoleTitle = "Role"
    private let kXpTitle = "Xp"
    private let kMemoriesTitle = "Memories"
    private let kKnowledgeTitle = "Knowledge"
    
    var body: some View {
        VStack {
            HStack {
                ByteProfileTopView(
                    title: kProfileInfoTitle,
                    value: $profileInfo
                )
                ByteProfileTopView(
                    title: kRoleTitle,
                    value: $role
                )
            }
            HStack {
                ByteProfileTopView(
                    title: kMemoriesTitle,
                    value: $memories
                )
//                ByteProfileBottomView(
//                    iconName: AppImages.kXpInfo,
//                    title: kXpTitle,
//                    value: xp
//                )
//                ByteProfileBottomView(
//                    iconName: AppImages.kMemoriesInfo,
//                    title: kMemoriesTitle,
//                    value: memories
//                )
//                ByteProfileBottomView(
//                    iconName: AppImages.kKnowledgeInfo,
//                    title: kKnowledgeTitle,
//                    value: knowledge
//                )
            }
        }
    }
}

#Preview {
    VStack {
        ByteProfileView(
            profileInfo: .constant("Male / 22y"),
            role: .constant("Assistant"),
            xp: .constant("1234"),
            memories: .constant("1111"),
            knowledge: .constant("2222")
        )
    }
    .frame(maxWidth: .infinity, maxHeight: 110)
    .background(.green)
    .padding()
}
