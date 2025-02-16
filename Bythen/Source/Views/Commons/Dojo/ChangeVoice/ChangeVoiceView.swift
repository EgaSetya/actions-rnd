//
//  ChangeVoiceView.swift
//  Bythen
//
//  Created by edisurata on 13/10/24.
//

import SwiftUI

struct ChangeVoiceView: View {
    @EnvironmentObject var mainState: MainViewModel
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ChangeVoiceViewModel
    
    private let voiceColumns = [
        GridItem(.adaptive(minimum: 100)),
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Base Voice")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(FontStyle.neueMontreal(.medium, size: 16))
                .padding(.vertical, 12)
            
            FlowLayout(items: viewModel.voices) { voice in
                VoiceTagChip(viewModel: voice)
            }
            .padding(.bottom, 12)
            
            Text("Accents")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(FontStyle.neueMontreal(.medium, size: 16))
                .padding(.vertical, 12)
            
            FlowLayout(items: viewModel.accents) { accent in
                VoiceTagChip(viewModel: accent)
            }
            .padding(.bottom, 12)
            
            Text("Age")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(FontStyle.neueMontreal(.medium, size: 16))
                .padding(.vertical, 12)
            
            FlowLayout(items: viewModel.ages) { age in
                VoiceTagChip(viewModel: age)
            }
            .padding(.bottom, 12)
            
            Text("Select Voice")
                .font(FontStyle.neueMontreal(.medium, size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
                .foregroundStyle(ByteColors.foreground(for: colorScheme))
            Text("Pick one of the presets we’ve generated for you.")
                .font(FontStyle.neueMontreal(size: 14))
                .foregroundStyle(ByteColors.foreground(for: colorScheme).opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
                .padding(.bottom, 12)
            
            switch viewModel.voiceSampleState {
            case .empty:
                VStack(spacing: 0) {
                    Image("report")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.gokuOrange600)
                        .frame(width: 48, height: 48)
                        .padding(8)
                        .padding(.top, 36)
                    Text("Voice Not Found")
                        .font(.neueMontreal(.medium, size: 20))
                        .foregroundStyle(ByteColors.foreground(for: colorScheme))
                        .padding(.top, 16)
                    Text("Try adjusting your settings and then try again.")
                        .font(.neueMontreal(size: 16))
                        .foregroundStyle(ByteColors.foreground(for: colorScheme))
                        .padding(.top, 4)
                }
            case .loading:
                LazyVGrid(columns: voiceColumns, spacing: 8) {
                    ForEach(0..<4) { _ in
                        Rectangle()
                            .fill(.totoroGrey100)
                            .overlay{
                                GeometryReader { geo in
                                    ShimmeringRectangle(width: geo.size.width, height: 80)
                                }
                                
                            }
                            .frame(height: 80)
                    }
                }
            case .result:
                LazyVGrid(columns: voiceColumns, spacing: 8) {
                    ForEach(viewModel.voiceSamples, id: \.self) { voiceSample in
                        VoiceSampleView(viewModel: voiceSample)
                    }
                }
            }
        }
        .background(ByteColors.background(for: colorScheme))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 16)
        .onAppear {
            viewModel.setMainState(state: mainState)
            viewModel.fetchData()
        }
        .onDisappear {
            viewModel.updateVoice()
        }
    }
}

#Preview {
    ChangeVoiceView(viewModel: ChangeVoiceViewModel.new())
        .environmentObject(MainViewModel.new())
}
