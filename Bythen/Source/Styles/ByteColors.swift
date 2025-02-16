//
//  AppThemes.swift
//  Bythen
//
//  Created by edisurata on 13/09/24.
//

import Foundation
import SwiftUI

class ByteColors {
    static func foreground(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return .white
        default:
            return .byteBlack
        }
    }

    static func background(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return .byteBlack
        default:
            return .white
        }
    }
    
    static func highlightOrange(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return .gokuOrange400
        default:
            return .gokuOrange300
        }
    }
}
