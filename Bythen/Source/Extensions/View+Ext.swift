//
//  View+Ext.swift
//  Bythen
//
//  Created by erlina ng on 05/10/24.
//
import SwiftUI

extension View {
    /// Sets the corner radius for the specified corners of the view.
    /// - Parameters:
    ///   - radius: The size of the corner radius to apply.
    ///   - corners: The corners of the view to round. This should be a `UIRectCorner` value.
    /// - Returns: A view with the specified corner radius applied to the given corners.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    /// Sets a square frame for the view, using the same size for both width and height.
    ///
    /// - Parameters:
    ///   - square: The size to be applied for both the width and height of the frame.
    /// - Returns: A view with the specified square frame.
    func frame(square: CGFloat) -> some View {
        self.frame(width: square, height: square)
    }
}

struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
