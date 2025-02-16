//
//  StepSlider.swift
//  Bythen
//
//  Created by edisurata on 14/10/24.
//

import SwiftUI

struct StepSlider: View {
    @Binding var value: Double
    @State var initialValue: Double
    var range: ClosedRange<Double>
    var trackHeight: CGFloat = 2
    @State private var step: Double = 1
    @State private var minValue: Double = 1
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                HStack {
                    ForEach(Int(range.lowerBound)...Int(range.upperBound - 1), id: \.self) { idx in
                        Capsule()
                            .fill(Int(value) > idx ? .gokuOrange600 : Color.gray.opacity(0.3))
                            .frame(height: trackHeight)
                            .overlay(content: {
                                Color.clear
                                    .contentShape(Rectangle())
                                    .frame(height: 28)
                                    .onTapGesture {
                                        value = Double(idx) + 1
                                    }
                            })
                    }
                }
                Circle()
                    .fill(isInitialState() ? .white : .gokuOrange400, strokeBorder: .appBlack, lineWidth: 2)
                    .frame(width: 28, height: 28)
                    .offset(x: geo.size.width * CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) - 14)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                let totalSteps = (range.upperBound - range.lowerBound) / step
                                let stepWidth = geo.size.width / CGFloat(totalSteps)
                                let newStepValue = round(gesture.location.x / stepWidth) * step + range.lowerBound
                                
                                value = min(max(newStepValue, range.lowerBound + 1), range.upperBound)
                            }
                    )
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
    
    func isInitialState() -> Bool {
        return value == initialValue
    }
}
