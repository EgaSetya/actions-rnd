//
//  Font+Custom.swift
//  Bythen
//
//  Created by edisurata on 26/10/24.
//

import SwiftUI
import UIKit

extension Font {
    static func foundersGrotesk(_ weight: Font.Weight = .regular, size: CGFloat = 12) -> Font {
        return FontStyle.foundersGrotesk(weight, size: size)
    }
    
    static func neueMontreal(_ weight: Font.Weight = .regular, size: CGFloat = 12) -> Font {
        return FontStyle.neueMontreal(weight, size: size)
    }
    
    static func dmMono(_ weight: Font.Weight = .regular, size: CGFloat = 12) -> Font {
        return FontStyle.dmMono(weight, size: size)
    }
    
    static func drukWide(size: CGFloat = 12) -> Font {
        return FontStyle.drukWide(size: size)
    }
}

extension Font {
    func toUIFont() -> UIFont {
        switch self {
        case .largeTitle:
            return UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title:
            return UIFont.preferredFont(forTextStyle: .title1)
        case .title2:
            return UIFont.preferredFont(forTextStyle: .title2)
        case .title3:
            return UIFont.preferredFont(forTextStyle: .title3)
        case .headline:
            return UIFont.preferredFont(forTextStyle: .headline)
        case .subheadline:
            return UIFont.preferredFont(forTextStyle: .subheadline)
        case .body:
            return UIFont.preferredFont(forTextStyle: .body)
        case .callout:
            return UIFont.preferredFont(forTextStyle: .callout)
        case .footnote:
            return UIFont.preferredFont(forTextStyle: .footnote)
        case .caption:
            return UIFont.preferredFont(forTextStyle: .caption1)
        case .caption2:
            return UIFont.preferredFont(forTextStyle: .caption2)
        default:
            // Provide a default UIFont if the Font is not a standard text style
            return UIFont.systemFont(ofSize: 12)
        }
    }
}
