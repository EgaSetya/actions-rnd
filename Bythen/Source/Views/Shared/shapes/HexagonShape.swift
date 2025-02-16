//
//  HexagonShape.swift
//  Bythen
//
//  Created by Darindra R on 09/12/24.
//

import SwiftUI

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height
        let radius = min(width, height) / 2 // Radius of the hexagon
        let centerX = width / 2
        let centerY = height / 2

        return Path { path in
            for i in 0 ..< 6 { // 6 sides of the hexagon
                // Rotate by 30 degrees to align the edges at the top and bottom
                let angle = (CGFloat(i) * (360 / 6) + 30) * CGFloat.pi / 180 // Convert to radians
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)

                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y)) // Move to the first vertex
                } else {
                    path.addLine(to: CGPoint(x: x, y: y)) // Draw lines to each vertex
                }
            }
            path.closeSubpath() // Close the hexagon shape
        }
    }
}
