//
//  HiveCountdownView.swift
//  Bythen
//
//  Created by erlina ng on 27/12/24.
//

import SwiftUI

struct HiveCountdownView: View {
    @StateObject private var viewModel: HiveCountdownViewModel

    init(seconds: Int) {
        _viewModel = StateObject(wrappedValue: HiveCountdownViewModel(seconds: seconds))
    }

    var body: some View {
        
        HStack(spacing: 4) {
            Spacer()
            
            Text("Free trial ends in ")
                .font(Font.neueMontreal(.regular, size: 14))
                .foregroundStyle(Color.white)
                
            Text(viewModel.formattedTime)
                .font(Font.dmMono(.medium, size: 14))
                .foregroundStyle(Color.white)
            
            Spacer()
        }
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.1))
        .border(Color.byteBlack400, width: 1)
    }
}
