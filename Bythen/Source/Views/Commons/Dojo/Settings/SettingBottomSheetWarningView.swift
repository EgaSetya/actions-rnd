//
//  Untitled.swift
//  Bythen
//
//  Created by erlina ng on 03/10/24.
//

import SwiftUI

struct SettingBottomSheetWarningView: View {
    var body: some View {
        HStack {
            Image("info.fill")
                .resizable()
                .frame(width: 16.5, height: 16.5)
                .padding(.leading, 8)
                .foregroundStyle(Color.red)
            Text("WARNING: THIS ACTION CANNOT BE UNDONE. PLEASE ONLY PROCEED IF YOU ARE SURE!")
                .font(FontStyle.dmMono(.medium, size: 11))
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color.byteRedBackground)
    }
}

