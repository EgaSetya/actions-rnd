//
//  DialogueView.swift
//  Bythen
//
//  Created by edisurata on 07/10/24.
//

import SwiftUI

struct DialogueView: View {
    @EnvironmentObject var mainState: MainViewModel
    
    private let kHeaderResponseLength = "Response Length"
    private let kContentResponseLength = "Choose whether you’d like your Byte to be direct and straightforward or more expressive and elaborative."
    private let kHeaderDialoguStyle = "Dialogue Style"
    private let kContentDialoguStyle = "Choose from a preset or customize your own dialogue style."
    private let kHeaderSampleDialogue = "Sample Dialogue"
    
    @StateObject var viewModel: DialogueViewModel
    @State var sliderRange: ClosedRange<Double> = 0...3
    @State private var isPresetPresent: Bool = false
    @FocusState private var customPresetFocused: Bool
    
    var body: some View {
        VStack {
            Text(kHeaderResponseLength)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 4)
                .padding(.top, 24)
                .font(FontStyle.neueMontreal(.medium, size: 18))
                .foregroundStyle(.appBlack)
            Text(kContentResponseLength)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.trailing, 64)
                .font(FontStyle.neueMontreal(size: 12))
                .foregroundStyle(.appBlack.opacity(0.7))
            
            HStack {
                Text("Short")
                    .font(FontStyle.dmMono(.medium, size: 16))
                Spacer()
                Text("Long")
                    .font(FontStyle.dmMono(.medium, size: 16))
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            StepSlider(
                value: $viewModel.responseLength,
                initialValue: viewModel.responseLength,
                range: sliderRange,
                trackHeight: 2
            )
            .padding(.horizontal, 24)
            
            Text(kHeaderDialoguStyle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 4)
                .font(FontStyle.neueMontreal(.medium, size: 18))
                .foregroundStyle(.appBlack)
            Text(kContentDialoguStyle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.trailing, 64)
                .font(FontStyle.neueMontreal(size: 12))
                .foregroundStyle(.appBlack.opacity(0.7))
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: viewModel.tapDialoguePreset) {
                        Circle()
                            .fill(
                                .white,
                                strokeBorder: .appBlack,
                                lineWidth: viewModel.dialogueStyle == .preset ? 7 : 3)
                            .frame(width: 20, height: 20)
                            .padding(8)
                    }
                    
                    Text("Preset")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(FontStyle.dmMono(.medium, size: 14))
                }
                .padding(.horizontal, 24)
                HStack {
                    Text(viewModel.dialogueStyleText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(FontStyle.neueMontreal(size: 12))
                        .foregroundStyle(.appBlack)
                        .padding(.vertical, 12)
                        .padding(.leading, 12)
                    Image("arrow-down")
                        .frame(width: 20, height: 20)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 22)
                }
                .background(
                    Rectangle().fill(.white, strokeBorder: Color.appBlack.opacity(0.3), lineWidth: 1))
                .padding(.leading, 60)
                .padding(.trailing, 24)
                .onTapGesture {
                    self.isPresetPresent.toggle()
                }
            }
            
            VStack {
                HStack {
                    Button(action: viewModel.tapDialogueCustom) {
                        Circle()
                            .fill(
                                .white,
                                strokeBorder: .appBlack,
                                lineWidth: viewModel.dialogueStyle == .custom ? 7 : 3)
                            .frame(width: 20, height: 20)
                            .padding(8)
                    }
                    
                    Text("Custom")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(FontStyle.dmMono(.medium, size: 14))
                }
                .padding(.horizontal, 24)
                
            }
            .padding(.top, 12)
            HStack {
                TextField("e.g. like Master Yoda or poetic.", text: $viewModel.customDialogueStyleText)
                    .focused($customPresetFocused)
                    .font(FontStyle.neueMontreal(size: 12))
                    .foregroundStyle(.appBlack)
                    .padding(.vertical, 12)
                    .padding(.leading, 12)
                    .padding(.trailing, 38)
                    .onChange(of: customPresetFocused) { focus in
                        if focus {
                            viewModel.setDialogueStyle(.custom)
                        }
                    }
            }
            .background(
                Rectangle().stroke(Color.appBlack.opacity(0.3), lineWidth: 1))
            .padding(.leading, 60)
            .padding(.trailing, 24)
            .padding(.bottom, 24)
            
            HStack {
                Text(kHeaderSampleDialogue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(FontStyle.neueMontreal(.medium, size: 18))
                    .foregroundStyle(.appBlack)
                
                Spacer()
                
                Button {
                    viewModel.previewDialogue()
                } label: {
                    HStack {
                        Image("sparkles")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.appBlack)
                            .padding(.vertical, 10)
                            .padding(.leading, 12)
                        
                        Text("PREVIEW")
                            .font(FontStyle.foundersGrotesk(.semibold, size: 14))
                            .padding(.trailing, 16)
                            .padding(.leading, 3)
                    }
                    .background(RoundedRectangle(cornerRadius: 18).fill(.appBlack.opacity(0.05)))
                    .padding(.trailing, 6)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 4)
            
            VStack {
                Text(viewModel.sampleDialoguePreview)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .font(FontStyle.neueMontreal(.regular, size: 14))
                    .lineSpacing(6)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
            }
            .background(
                Rectangle().stroke(.appBlack.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .padding(.bottom, 50)
        }
        .onAppear(perform: {
            viewModel.setMainState(state: mainState)
            viewModel.fetchData()
        })
        .onDisappear(perform: {
            viewModel.updateDialogue()
        })
        .sheet(isPresented: $isPresetPresent) {
            VStack {
                ScrollView {
                    Text("Preset")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(FontStyle.neueMontreal(.medium, size: 24))
                        .foregroundStyle(.appBlack)
                        .padding(.top, 32)
                        .padding(.horizontal, 16)
                    
                    LazyVStack {
                        ForEach(viewModel.dialoguePresets, id:\.id) { preset in
                            HStack {
                                Text(preset.label)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(FontStyle.neueMontreal(size: 16))
                                    .foregroundStyle(.appBlack)
                                    .padding(16)
                                
                                if viewModel.dialogueStyleText == preset.value {
                                    Image("check-chevron")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(16)
                                }
                            }
                            .background(.white)
                            .onTapGesture {
                                viewModel.dialogueStyleText = preset.value
                                viewModel.setDialogueStyle(.preset)
                                isPresetPresent.toggle()
                            }
                            Color.appBlack
                                .opacity(0.1)
                                .frame(maxWidth: .infinity, maxHeight: 1)
                                .padding(.horizontal, 16)
                        }
                    }
                }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.automatic)
        }
    }
}

#Preview {
    DialogueView(viewModel: DialogueViewModel.new())
        .environmentObject(MainViewModel.new())
}
