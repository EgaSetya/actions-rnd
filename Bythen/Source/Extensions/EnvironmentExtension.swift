//
//  EnvironmentExtension.swift
//  Bythen
//
//  Created by edisurata on 13/09/24.
//

import SwiftUI

struct EditingFocusStateKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isEditingFocused: Binding<Bool> {
        get { self[EditingFocusStateKey.self] }
        set { self[EditingFocusStateKey.self] = newValue }
    }
}
