//
//  BaseViewModel.swift
//  Bythen
//
//  Created by edisurata on 19/09/24.
//

import Foundation

class BaseViewModel: ObservableObject, Identifiable, Equatable, Hashable {
    @Published var isLoading = false
    @Published var isShowError = false

    var id = UUID()
    var index: Int
    var mainState: MainViewModel?

    init(index: Int = 0) {
        self.index = index
    }

    func setMainState(state: MainViewModel) {
        mainState = state
    }

    func handleError(_ err: any Error, showReadable: Bool = false) {
        if let state = mainState {
            if let err = err as? HttpError {
                state.showError(errMsg: showReadable ? err.readableMessage : err.message)
                if err.code == .unauthorized {
                    DispatchQueue.main.async {
                        if let vm = state.sidemenuContentVM {
                            vm.logout(method: .force)
                            state.sidemenuContentVM = nil
                        }
                    } 
                }
            } else if let err = err as? AppError {
                state.showError(errMsg: err.message)
            } else {
                Logger.logError(err: err)
            }
        }
    }

    func setLoading(isLoading: Bool) {
        DispatchQueue.main.async {
            if let state = self.mainState {
                state.showPageLoading(isLoading: isLoading)
            }
        }
    }
    
    static func == (lhs: BaseViewModel, rhs: BaseViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // FIXME: Check this later, this could lead to retain cycle
    // SideMenuContentViewModel conform to BaseViewModel, BaseViewModel use and retain SideMenuContentViewModel
    func globalCheckFreeTrial() {
        if let state = mainState, let vm = state.sidemenuContentVM {
            vm.checkFreeTrial()
        }
    }
}
