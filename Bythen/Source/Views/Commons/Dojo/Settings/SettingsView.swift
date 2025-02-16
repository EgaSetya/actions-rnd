//
//  SettingsView.swift
//  Bythen
//
//  Created by erlina ng on 02/10/24.
//
import SwiftUI

struct SettingsView: View {
    @State var onTapSetting: (Bool) -> Void
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Setting")
                    .font(FontStyle.neueMontreal(.medium, size: 24))
                    .padding(.bottom, 12)
                    .padding(.top, 24)
                
                SettingCardView(onTap: {
                    withAnimation(.easeInOut) {
                        onTapSetting(true)
                    }
                })
                
                Spacer()
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(.horizontal, 24)
        }
    }
}

struct SettingCardView: View {
    private var onTap: (() -> Void)
    
    init(onTap: @escaping () -> Void) {
        self.onTap = onTap
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                VStack(alignment: .leading) {
                    Text("RESET BYTE")
                        .font(FontStyle.foundersGrotesk(.bold, size: 14))
                        .foregroundStyle(Color.byteBlack)
                        .lineSpacing(16)
                    Text("You can reset your Byte to default or wipe all settings.")
                        .font(FontStyle.neueMontreal(.regular, size: 12))
                        .foregroundStyle(Color.byteBlack600)
                        .lineSpacing(16)
                }
            }
            Spacer()
        }
        .background()
        .onTapGesture {
            onTap()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 24)
        .border(Color.byteBlack400, width: 2)

    }
}
