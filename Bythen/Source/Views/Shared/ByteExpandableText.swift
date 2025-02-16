//
//  ByteExpandableText.swift
//  Bythen
//
//  Created by erlina ng on 23/10/24.
//
import SwiftUI
import UIKit

struct ByteExpandableText: View {
    
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    @State private var shrinkText: String
    @State private var textSize: CGSize = CGSize(width: 0, height: 0)
    
    @Binding private var text: String
    private let font: UIFont
    private let lineLimit: Int
    
    init(_ text: Binding<String>, lineLimit: Int, font: UIFont? = nil) {
        _text = text
        _shrinkText = State(wrappedValue: text.wrappedValue)
        self.lineLimit = lineLimit
        
        if let font {
            self.font = font
        } else {
            if let fontFamily = FontStyle.neueMontrealFontFamilty[.regular], let customFont = UIFont(name: fontFamily, size: 12) {
                self.font = customFont
            } else {
                self.font = .systemFont(ofSize: 12)
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                Text(self.expanded ? text : shrinkText).foregroundColor(.byteBlack.opacity(0.7)) + Text(moreLessText)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
            }
            .animation(.easeInOut(duration: 1.0), value: false)
            .lineLimit(expanded ? nil : lineLimit)
            .lineSpacing(4)
            .font(Font(font))
            
            ScrollView(.vertical) {
                Text(text)
                    .lineLimit(lineLimit)
                    .font(Font(font))
                    .foregroundStyle(.byteBlack.opacity(0.7))
                    .lineSpacing(4)
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onFirstAppear {
                                    textSize = proxy.size
                                    calculateTextSize(textSize: textSize)
                                }
                                .onChange(of: text) { newValue in
                                    shrinkText = newValue
                                    // If the geometry size changes, update the text size
                                    textSize = proxy.size
                                    calculateTextSize(textSize: textSize)
                                }
                        }
                    )
                
            }
            .opacity(0.0)
            .disabled(true)
            .frame(height: 0.0)
            
            if truncated {
                Button(action: {
                    expanded.toggle()
                }, label: {
                    HStack { /// taking tap on only last line, As it is not possible to get 'see more' location
                        Spacer()
                        Text("")
                    }.opacity(0)
                })
            }
        }
    }
    
    private var moreLessText: String {
        if !truncated {
            return ""
        } else {
            return self.expanded ? " See less" : ".. See more"
        }
    }
    
    /// For calculating shrinkText's prefix
    /// calculateTextSize(textSize: `text with lineLimit size` )
    private func calculateTextSize(textSize: CGSize) {
        
        truncated = false ///reset truncated value
        let size = CGSize(width: textSize.width, height: .greatestFiniteMagnitude)
        let attributes:[NSAttributedString.Key:Any] = [NSAttributedString.Key.font: font]
        
        /// Binary search until mid == low && mid == high
        var low  = 0
        var height = shrinkText.count
        var mid = height /// start from top so that if text contain we does not need to loop
        
        while (max((height - low), 0) > 1) {
            let attributedText = NSAttributedString(string: shrinkText + moreLessText, attributes: attributes)
            let boundingRect = attributedText.boundingRect(with: size, options: [.usesLineFragmentOrigin], context: nil) ///Size of shrinkText + moreLessText
            
            if boundingRect.size.height > textSize.height { ///shrinkText + moreLessText  > text with lineLimit Size
                truncated = true
                height = mid
                mid = (height + low)/2
                
            } else {
                if mid == text.count {
                    break /// shrinkText == text (text < lineLimit)
                } else {
                    low = mid
                    mid = (low + height)/2
                }
            }
            shrinkText = String(text.prefix(mid))
        }
        
        if truncated {
            shrinkText = String(shrinkText.prefix(max(shrinkText.count - 2, 0)))  /// -2 extra as highlighted text is bold
        }
    }
}
