//
//  FontStyle.swift
//  Bythen
//
//  Created by edisurata on 30/08/24.
//

import Foundation
import SwiftUI
import UIKit

class FontStyle {
    static var foundersGroteskFontFamily: [Font.Weight : String] = [
        .regular: "FoundersGrotesk-Regular",
        .medium: "FoundersGrotesk-Medium",
        .semibold: "FoundersGroteskCondensed-SmBd"
    ]
    
    static var neueMontrealFontFamilty: [Font.Weight : String] = [
        .regular: "NeueMontreal-Regular",
        .medium: "NeueMontreal-Medium",
        .bold: "NeueMontreal-Bold",
        .light: "NeueMontreal-Light"
    ]
    
    static var dmMonoFontFamily: [Font.Weight : String] = [
        .regular: "DMMono-Regular",
        .medium: "DMMono-Medium"
    ]
    
    static var drukWideFont: [Font.Weight: String] = [
        .bold: "DrukWide-Bold"
    ]
    
    @available(*, deprecated, message: "Use foundersGrotesk() instead.")
    static func firstFont(_ weight: Font.Weight = .regular, size: CGFloat = 12) -> Font {
        return customFont(foundersGroteskFontFamily[weight], weight: weight, size: size)
    }
    
    @available(*, deprecated, message: "Use neueMontreal() instead.")
    static func secondFont(_ weight: Font.Weight = .regular, size: CGFloat = 12) -> Font {
        return customFont(neueMontrealFontFamilty[weight], weight: weight, size: size)
    }
    
    @available(*, deprecated, message: "Use dmMono() instead.")
    static func thirdFont(_ weight: Font.Weight = .regular, size: CGFloat = 12) -> Font {
        return customFont(dmMonoFontFamily[weight], weight: weight, size: size)
    }
    
    static func foundersGrotesk(_ weight: Font.Weight = .regular, size: CGFloat = 12) -> Font {
        return customFont(foundersGroteskFontFamily[weight], weight: weight, size: size)
    }
    
    static func neueMontreal(_ weight: Font.Weight = .regular, size: CGFloat = 12) -> Font {
        return customFont(neueMontrealFontFamilty[weight], weight: weight, size: size)
    }
    
    static func dmMono(_ weight: Font.Weight = .regular, size: CGFloat = 12) -> Font {
        return customFont(dmMonoFontFamily[weight], weight: weight, size: size)
    }
    
    static func drukWide(_ weight: Font.Weight = .bold, size: CGFloat = 12) -> Font {
        return customFont(drukWideFont[weight], weight: weight, size: size)
    }
    
    static func customFont(_ fontFamily: String?, weight: Font.Weight, size: CGFloat = 12) -> Font {
        if let fontName = fontFamily, let _ = UIFont(name: fontName, size: size) {
            return .custom(fontName, size: size)
        }
        
        return .system(size: size, weight: weight)
    }
}
