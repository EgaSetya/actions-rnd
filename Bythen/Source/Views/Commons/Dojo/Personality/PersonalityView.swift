//
//  PersonalityView.swift
//  Bythen
//
//  Created by erlina ng on 12/10/24.
//

import SwiftUI

struct PersonalityView: View {
    /// Properties
    @State var isShowBottomSheet: Bool = false
    @State var traitTextField = ""
    @State var isShowTraitTextField = false
    @StateObject var viewModel: PersonalityViewModel

    init(viewModel: PersonalityViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            VStack {
                backStory
                    .padding(.top, 24)

                personalitiesSliders
                    .padding(.top, 24)

                additionalTraits
                    .padding(.top, 24)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .onAppear {
                viewModel.fetchPersonalities()
            }
            .onDisappear {
                viewModel.updatePersonality()
            }

            if viewModel.isLoading {
                VStack {
                    NetworkProgressView()
                        .zIndex(1)
                }
            }
        }
        .background(.white)
    }

    var backStory: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("Backstory")
                    .font(FontStyle.neueMontreal(.medium, size: 18))
                Spacer()

                Image("pen.sharp.solid")
                    .resizable()
                    .foregroundStyle(.byteBlack)
                    .frame(width: 16, height: 16)
                    .padding(10)
                    .background(.appBlack.opacity(0.05))
                    .clipShape(Circle())
                    .onTapGesture {
                        isShowBottomSheet = true
                    }
            }
            .padding(.bottom, 8)
            ByteExpandableText(
                $viewModel.description,
                lineLimit: 3
            )
        }
        .fullScreenCover(isPresented: $isShowBottomSheet) {
            BackstoryView(
                viewModel: viewModel.getBackstoryViewModel(),
                onSaveContent: { viewModel.fetchBuild() }
            )
        }
    }

    var personalitiesSliders: some View {
        VStack {
            HStack {
                Text("Personality")
                    .font(FontStyle.neueMontreal(.medium, size: 18))
                Spacer()
            }
            .padding(.bottom, 24)
            VStack(spacing: 0) {
                ForEach($viewModel.bytePersonalities) { personality in
                    VStack {
                        HStack {
                            Text(personality.minLabel.wrappedValue)
                                .font(FontStyle.dmMono(.regular, size: 12))
                            Spacer()
                            Text(personality.maxLabel.wrappedValue)
                                .font(FontStyle.dmMono(.regular, size: 12))
                        }
                        StepSlider(
                            value: personality.currentValueDouble,
                            initialValue: personality.currentValueDouble.wrappedValue,
                            range: personality.rangeSlide.wrappedValue,
                            trackHeight: 2
                        ).frame(height: 56)
                    }
                }
            }
        }
    }

    var additionalTraits: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Additional Traits")
                    .font(FontStyle.neueMontreal(.medium, size: 18))
                Spacer()
            }

            Text("You can add any traits to give your Byte even more distinct personalities. e.g dry humor, pet-lover etc.")
                .font(FontStyle.neueMontreal(.regular, size: 12))
                .foregroundStyle(Color.byteBlack800)
                .padding(.bottom, 4)

            FlowLayout(items: $viewModel.byteTraits.wrappedValue) { trait in
                ByteChip(text: trait, onTap: {
                    viewModel.deleteTrait(newValue: trait, onCompletion: nil)
                })
                .padding(4)
            }

            byteChipTextField
                .padding(.top, 4)
        }
    }

    var byteChipTextField: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                if isShowTraitTextField {
                    TextField(
                        "Input tags and press return to add",
                        text: $traitTextField,
                        onCommit: {
                            if traitTextField != "" { /// Don't submit empty string
                                viewModel.addTraits(
                                    newValue: $traitTextField.wrappedValue,
                                    onCompletion: {
                                        traitTextField = ""
                                        isShowTraitTextField.toggle()
                                    }
                                )
                            }
                        }
                    )
                    .font(FontStyle.neueMontreal(.regular, size: 16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .border(Color.byteBlack400, width: 1)
                    .animation(.easeInOut(duration: 0.5), value: isShowTraitTextField)
                    .onChange(of: traitTextField, perform: { newValue in
                        if newValue.count > 15 {
                            traitTextField = String(newValue.prefix(15))
                        }
                    })
                }

                byteChipTextFieldButton
            }
            if isShowTraitTextField {
                Text("\($traitTextField.wrappedValue.count) / 15")
                    .font(FontStyle.neueMontreal(.regular, size: 14))
                    .foregroundStyle(Color.byteBlack400)
            }
        }
    }

    var byteChipTextFieldButton: some View {
        HStack(spacing: 8) {
            Image(systemName: isShowTraitTextField ? "xmark" : "plus")
                .tint(.byteBlack800)
                .frame(width: 20, height: 20)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background {
            Circle()
                .fill(
                    .clear,
                    strokeBorder: viewModel.byteTraits.count < 5 ? .appBlack : .byteBlack800,
                    lineWidth: 1
                )
        }
        .onTapGesture {
            if viewModel.byteTraits.count < 5 {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isShowTraitTextField.toggle()
                }
            }
        }
    }
}
