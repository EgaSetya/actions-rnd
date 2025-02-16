//
//  SettingBottomSheetView.swift
//  Bythen
//
//  Created by erlina ng on 03/10/24.
//

import SwiftUI

struct SettingBottomSheetView: View {
    @EnvironmentObject var mainState: MainViewModel
    
    @StateObject var viewModel: SettingBottomSheetViewModel
    internal init(viewModel: SettingBottomSheetViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Reset Byte")
                    .font(FontStyle.foundersGrotesk(.bold, size: 28))
                Spacer()
            }
            
            SettingBottomSheetItem(
                isSelected: $viewModel.settingBottomSheetItemStates[0].isSelected,
                title: viewModel.settingBottomSheetItemStates[0].title,
                subtitle: viewModel.settingBottomSheetItemStates[0].subtitle
            ) { isSelected in
                viewModel.onTapRadioButton(id: 0)
                isSelected.wrappedValue = viewModel.selectedItemId == viewModel.settingBottomSheetItemStates[0].id
            }
            
            SettingBottomSheetItem(
                isSelected: $viewModel.settingBottomSheetItemStates[1].isSelected,
                title: viewModel.settingBottomSheetItemStates[1].title,
                subtitle: viewModel.settingBottomSheetItemStates[1].subtitle
            ) { isSelected in
                viewModel.onTapRadioButton(id: 1)
                isSelected.wrappedValue = viewModel.selectedItemId == viewModel.settingBottomSheetItemStates[1].id
            }
            
            SettingBottomSheetWarningView()
            
            BasicSquareButton(title: "Confirm Reset") {
                viewModel.onTapButton()
            }
            .frame(height: 48)
        }
        .padding(16)
        .onAppear {
            viewModel.setMainState(state: mainState)
        }
    }
}

struct SettingBottomSheetItem: View {
    @Binding var isSelected: Bool
    @State var title: String
    @State var subtitle: String
    @State var onTap: ((Binding<Bool>) -> Void)?
    
    var body: some View {
        HStack(alignment: .top) {
            ByteRadioButton(checked: $isSelected)
                .padding(.top, 4)
            VStack(alignment: .leading) {
                Text(title)
                    .font(FontStyle.neueMontreal(.semibold, size: 18))
                Text(subtitle)
                    .foregroundStyle(Color.byteBlack600)
                    .font(FontStyle.neueMontreal(.regular, size: 14))
            }
            Spacer()
        }
        .onTapGesture {
            onTap?($isSelected)
        }
    }
}


