//
//  SettingBottomSheetViewModel.swift
//  Bythen
//
//  Created by erlina ng on 03/10/24.
//
import SwiftUI

class SettingBottomSheetViewModel: BaseViewModel {    
    private let byteBuildService: ByteBuildService = ByteBuildService()
    internal var byteBuild: ByteBuild
    internal var onComplete: () -> Void
    @Published internal var selectedItemId: Int = 0
    @Published internal var settingBottomSheetItemStates = [
        SettingBottomSheetItemState(
            id: 0,
            isSelected: true,
            title: "Reset to Default",
            subtitle: "Restore your Byte to its default Dojo settings"
        ),
        SettingBottomSheetItemState(
            id: 1,
            isSelected: false,
            title: "Wipe All",
            subtitle: "Start fresh by clearing all Dojo settings."
        )
    ]
    
    internal init(byteBuild: ByteBuild, onComplete: @escaping () -> Void) {
        self.byteBuild = byteBuild
        self.onComplete = onComplete
        super.init()
    }
    
    internal func onTapRadioButton(id: Int) {
        selectedItemId = id
        settingBottomSheetItemStates[0].isSelected = id == 0
        settingBottomSheetItemStates[1].isSelected = id == 1
    }
    
    internal func onTapButton() {
        if selectedItemId == 0 {
            resetProfile()
        } else {
            wipeProfile()
        }
    }
    
    internal func resetProfile() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            let params = CreateBuildParams(
                byteID: self.byteBuild.byteData.byteID,
                byteSymbol: self.byteBuild.byteData.byteSymbol,
                mode: "factory",
                byteName: self.byteBuild.byteName,
                age: self.byteBuild.age,
                gender: self.byteBuild.gender.rawValue
            )
            
            defer {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.setLoading(isLoading: false)
                    self.onComplete()
                }
            }

            DispatchQueue.main.async {
                self.setLoading(isLoading: true)
            }

            do {
                try await self.byteBuildService.createBuild(params: params)
            } catch let err as HttpError {
                DispatchQueue.main.async {
                    self.handleError(err)
                }
            }
        }
    }
    
    internal func wipeProfile() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            defer {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.setLoading(isLoading: false)
                    self.onComplete()
                }
            }
            
            DispatchQueue.main.async {
                self.setLoading(isLoading: true)
            }
            
            do {
                try await self.byteBuildService.wipeProfile(byteID: self.byteBuild.byteId, byteSymbol: self.byteBuild.byteSymbol)
            } catch let err as HttpError {
                DispatchQueue.main.async {
                    self.handleError(err)
                }
            }
        }
    }
}

struct SettingBottomSheetItemState: Identifiable {
    var id: Int
    var isSelected: Bool
    var title: String
    var subtitle: String
}
