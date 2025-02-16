//
//  RoundCornerTopShape.swift
//  Bythen
//
//  Created by edisurata on 20/09/24.
//

import SwiftUI

struct RoundedTopCorner: Shape {
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: radius, height: radius), style: .continuous)
        return path
    }
}
