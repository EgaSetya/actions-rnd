//
//  View+Analytics.swift
//  Bythen
//
//  Created by edisurata on 22/11/24.
//

import SwiftUI

extension View {
    func trackView(page: String, className: String, params: [String: Any]? = nil) -> some View {
        modifier(FirstAppearanceActionModifier(action: {
            AnalyticService.shared.trackPageView(page: page, className: className, params: params)
        }))
    }
}
