//
//  View+IsHidden.swift
//  Bythen
//
//  Created by Darindra R on 22/09/24.
//

import Foundation
import SwiftUI

public extension View {
    @ViewBuilder
    func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
