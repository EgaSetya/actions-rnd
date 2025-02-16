import SwiftUI

struct ColorPickerView: View {
    @Binding var isPresent: Bool
    
    var onSelectColor: (_ color: Color) -> Void
    @State private var selectedColor: Color = .blue   // Selected color
    @State private var opacity: Double = 1.0          // Opacity (Alpha)
    @State private var hue: Double = 240.0            // Hue value
    @State private var brightness: Double = 0.5       // Brightness value
    @State private var saturation: Double = 0.8       // Saturation value
    @State private var hexColor: String = "#4F46E5"   // Hex color code
    @State private var opacityText: String = "100 %"
    
    var body: some View {
        VStack {
            // Color selection square (Brightness & Saturation)
            HStack {
                Button(action: {
                    isPresent = false
                    onSelectColor(selectedColor)
                }, label: {
                    Text("Done")
                        .padding(16)
                })
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            ColorSelectionSquare(hue: $hue, saturation: $saturation, brightness: $brightness)
                .frame(height: 110)
                .padding(.horizontal, 16)
            
            // Hue slider
            ZStack {
                // Background gradient for hue spectrum
                LinearGradient(gradient: Gradient(colors: createHueColors()), startPoint: .leading, endPoint: .trailing)
                    .frame(height: 8)
                    .padding(.horizontal, 16)
                
                // Slider for hue selection
                Slider(value: $hue, in: 0...360, step: 1)
                    .accentColor(.clear)
                    .background(.clear)
                    .padding(.horizontal, 16)
            }
            .padding(.top, 8)

            // Opacity slider
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.black.opacity(0), .black.opacity(1)]), startPoint: .leading, endPoint: .trailing)
                    .frame(height: 8)
                    .padding(.horizontal, 16)
                Slider(value: $opacity, in: 0...1)
                    .accentColor(.clear)
                    .background(.clear)
                    .padding(.horizontal, 16)
            }
            .padding(.top, 8)

            // Hex Color Input
            HStack {
                Text("Hex : ")
                    .padding(.leading, 16)
                TextField("#4F46E5", text: $hexColor)
                    .padding(10)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .frame(width: 100)
                    .onChange(of: hexColor, perform: { newValue in
                        if let uiColor = UIColor(hex: newValue) {
                            selectedColor = Color(uiColor)
                        }
                    })
                TextField("", text: $opacityText)
                    .padding(10)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .frame(width: 100)
                    .onChange(of: hexColor, perform: { newValue in
                        if let uiColor = UIColor(hex: newValue) {
                            selectedColor = Color(uiColor)
                        }
                    })
                
                selectedColor
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
        }
        .background(.white)
        .onChange(of: hue) { _ in updateColor() }
        .onChange(of: saturation) { _ in updateColor() }
        .onChange(of: brightness) { _ in updateColor() }
        .onChange(of: opacity) { _ in updateColor() }
        .onChange(of: selectedColor) { newColor in
            hexColor = newColor.toHexString()
        }
    }
    
    // Function to update the selected color
    func updateColor() {
        selectedColor = Color(hue: hue / 360.0, saturation: saturation, brightness: brightness).opacity(opacity)
        opacityText = "\(Int(opacity * 100)) %"
        hexColor = selectedColor.toHexString()
    }
    
    private func createHueColors() -> [Color] {
        (0...360).map { angle in
            Color(hue: Double(angle) / 360.0, saturation: 1.0, brightness: 1.0)
        }
    }
}

// View for the color selection square
struct ColorSelectionSquare: View {
    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Hue-based gradient
                LinearGradient(gradient: Gradient(colors: [
                    Color(hue: hue / 360.0, saturation: 0, brightness: 1.0),
                    Color(hue: hue / 360.0, saturation: 1.0, brightness: 1.0)
                    
                ]), startPoint: .leading, endPoint: .trailing)
                
                // Brightness-based gradient
                LinearGradient(gradient: Gradient(colors: [
                    Color.clear,
                    Color.black.opacity(1.0)
                ]), startPoint: .top, endPoint: .bottom)
                
                // Circular handle
                Circle()
                    .stroke(.white, lineWidth: 2)
                    .frame(width: 20, height: 20)
                    .shadow(radius: 2)
                    .position(x: CGFloat(saturation) * geometry.size.width,
                              y: CGFloat(1.0 - brightness) * geometry.size.height)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let newSaturation = value.location.x / geometry.size.width
                                let newBrightness = 1.0 - value.location.y / geometry.size.height
                                
                                saturation = min(max(newSaturation, 0), 1)
                                brightness = min(max(newBrightness, 0), 1)
                            }
                    )
            }
        }
    }
}

// Color conversion extensions
extension Color {
    func toHexString() -> String {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0]
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }

        guard hexFormatted.count == 6 else {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// Preview
#Preview {
    @State var isShow: Bool = false
    
    return VStack {
        Spacer()
        ColorPickerView(isPresent: $isShow) { color in
        }
        .frame(maxWidth: .infinity, maxHeight: 326)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.green)
}
