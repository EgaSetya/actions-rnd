//
//  MarqueeView.swift
//  Bythen
//
//  Created by erlina ng on 04/11/24.
//

import SwiftUI

struct MarqueeView<Content: View>: View {
    @ViewBuilder var content: Content
    @State private var containerWidth: CGFloat? = nil
    @State private var model: MarqueeModel
    private var targetVelocity: Double
    private var spacing: CGFloat
    
    init(targetVelocity: Double, spacing: CGFloat = 10, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._model = .init(wrappedValue: MarqueeModel(targetVelocity: targetVelocity, spacing: spacing))
        self.targetVelocity = targetVelocity
        self.spacing = spacing
    }
    
    var extraContentInstances: Int {
        let contentPlusSpacing = ((model.contentWidth ?? 0) + model.spacing)
        guard contentPlusSpacing != 0 else { return 1 }
        return Int(((containerWidth ?? 0) / contentPlusSpacing).rounded(.up))
    }
    
    var body: some View {
        TimelineView(.animation) { context in
            HStack(spacing: model.spacing) {
                HStack(spacing: model.spacing) {
                    content
                }
                .measureWidth { model.contentWidth = $0 }
                ForEach(Array(0..<extraContentInstances), id: \.self) { _ in
                    content
                }
            }
            .offset(x: model.offset)
            .fixedSize()
            .onChange(of: context.date) { newDate in
                DispatchQueue.main.async {
                    model.tick(at: newDate)
                }
            }
        }
        .measureWidth { containerWidth = $0 }
        .onAppear { model.previousTick = .now }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing) // Align right for right-to-left
    }
    
    private func throttle(delay: Double, action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            action()
        }
    }
}

struct MarqueeModel {
    var contentWidth: CGFloat? = nil
    var offset: CGFloat = 0
    var dragStartOffset: CGFloat? = nil
    var dragTranslation: CGFloat = 0
    var currentVelocity: CGFloat = 0
    
    var previousTick: Date = .now
    var targetVelocity: Double
    var spacing: CGFloat
    
    init(targetVelocity: Double, spacing: CGFloat) {
        self.targetVelocity = targetVelocity
        self.spacing = spacing
    }
    
    mutating func tick(at time: Date) {
        let delta = time.timeIntervalSince(previousTick)
        defer { previousTick = time }
        currentVelocity += (targetVelocity - currentVelocity) * delta * 3
        
        if let dragStartOffset {
            offset = dragStartOffset + dragTranslation
        } else {
            offset += delta * currentVelocity // Change direction here
        }
        
        if let c = contentWidth {
            offset.formTruncatingRemainder(dividingBy: c + spacing)
            while offset < -c {
                offset += c + spacing
            }
        }
    }
}

extension View {
    func measureWidth(_ onChange: @escaping (CGFloat) -> ()) -> some View {
        background {
            GeometryReader { proxy in
                let width = proxy.size.width
                Color.clear
                    .onAppear {
                        DispatchQueue.main.async {
                            onChange(width)
                        }
                    }.onChange(of: width) {
                        onChange($0)
                    }
            }
        }
    }
}
