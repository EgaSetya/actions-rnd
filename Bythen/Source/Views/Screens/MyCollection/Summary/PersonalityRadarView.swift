//
//  PersonalityRadarView.swift
//  Bythen
//
//  Created by edisurata on 03/09/24.
//

import SwiftUI

struct PersonalityRadarView: View {
    @Environment(\.colorScheme) var theme
    
    let dataPoints: [Double]
    let labels: [String]
    let maxValue: Double
    @State private var containerWidth: CGFloat = 120
    @State private var containerSize: CGSize = CGSize(width: 120, height: 120)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Draw the circular radar graph background grid
                ForEach(1...5, id: \.self) { i in
                    Circle()
                        .stroke(ByteColors.foreground(for: theme).opacity(0.2), lineWidth: 1)
                        .scaleEffect(CGFloat(i) / 5)
                }
                
                // Draw the axes
                ForEach(0..<6) { i in
                    let endPoint = CGPoint(
                        x: cos(angle(for: i)) * containerWidth / 2.0,
                        y: sin(angle(for: i)) * containerWidth / 2
                    )
                    
                    Line(from: .zero, to: endPoint)
                        .stroke(ByteColors.foreground(for: theme).opacity(0.2), lineWidth: 1)
                    
                    
                    Circle()
                        .stroke(ByteColors.foreground(for: theme).opacity(0.2), lineWidth: 2)
                        .frame(
                            width: pointCircleWidth(),
                            height: pointCircleWidth()
                        )
                        .position(x: endPoint.x + containerWidth / 2,
                                  y: endPoint.y + containerWidth / 2)
                    
                    Rectangle()
                        .fill(ByteColors.foreground(for: theme))
                        .frame(
                            width: pointCircleWidth() / 3,
                            height: pointCircleWidth() / 3
                        )
                        .position(x: endPoint.x + containerWidth / 2,
                                  y: endPoint.y + containerWidth / 2)
                    
                    
                    let labelPosition = labelPos(i)
                    
                    HStack {
                        Text(labels[i])
                            .font(FontStyle.neueMontreal(size: 10))
                            .foregroundColor(ByteColors.foreground(for: theme))
                        + Text(" [\(Int(dataPoints[i]*100))%]")
                            .font(FontStyle.neueMontreal(.medium, size: 10))
                            .foregroundColor(ByteColors.foreground(for: theme))
                    }
                    .position(x: endPoint.x + labelPosition.x,
                              y: endPoint.y + labelPosition.y
                    )
                    
                }
                
                // Plot the data points and connect them
                Path { path in
                    let points = scaledPoints(for: containerSize)
                    path.move(to: points[0])
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                    path.closeSubpath()
                }
                .fill(LinearGradient(colors: [ByteColors.foreground(for: theme), ByteColors.foreground(for: theme).opacity(0.1)], startPoint: .trailing, endPoint: .leading))
                .overlay(
                    Path { path in
                        let points = scaledPoints(for: containerSize)
                        path.move(to: points[0])
                        for point in points.dropFirst() {
                            path.addLine(to: point)
                        }
                        path.closeSubpath()
                    }
                        .stroke(ByteColors.foreground(for: theme), lineWidth: 1)
                )
            }
            .frame(width: containerWidth, height: containerWidth)
            .position(x: containerWidth, y: containerWidth)
            .onAppear(perform: {
                containerWidth = min(geometry.size.width, geometry.size.height) / 2
                containerSize = CGSize(width: containerWidth, height: containerWidth)
            })
            
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func angle(for index: Int) -> Double {
        let offset = Double.pi / 2
        return Double(index) * 2 * .pi / 6 - offset
    }
    
    private func labelPos(_ i: Int) -> CGPoint {
        let verticalPoint = [0, 3]
        let labelX = cos(angle(for: i)) * (verticalPoint.contains(i) ? 0 : 70)
        let labelY = sin(angle(for: i)) * (verticalPoint.contains(i) ? 20 : 0)
        return CGPoint(
            x: labelX + containerWidth / 2.0,
            y: labelY + containerWidth / 2.0)
        
    }

    private func scaledPoints(for size: CGSize) -> [CGPoint] {
        dataPoints.enumerated().map { index, value in
            let scale = value / maxValue
            let x = cos(angle(for: index)) * scale * size.width / 2 + size.width / 2
            let y = sin(angle(for: index)) * scale * size.width / 2 + size.height / 2
            return CGPoint(x: x, y: y)
        }
    }
    
    private func pointCircleWidth() -> CGFloat {
        return containerWidth / 10
    }
}

struct Line: Shape {
    var from: CGPoint
    var to: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: from.x + rect.width / 2, y: from.y + rect.height / 2))
        path.addLine(to: CGPoint(x: to.x + rect.width / 2, y: to.y + rect.height / 2))
        return path
    }
}

#Preview {
    VStack {
        PersonalityRadarView(
            dataPoints: [0.2, 0.70, 0.2, 0.8, 0.8, 0.6], // Your data points, scaled to 1.0
            labels: [
                "Conventional",
                "Extravert",
                "Lively",
                "Spontaneous",
                "Emphathetic",
                "Agreeable"
            ],    // Labels for each axis
            maxValue: 1.0
        )
        .frame(maxWidth: .infinity)
        .padding()
    }
    .background(.red)
}
