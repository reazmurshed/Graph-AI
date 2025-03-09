import SwiftUI

// MARK: - View Modifiers
struct NeonText: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: 10)
            .shadow(color: color, radius: 10)
    }
}

struct NeonBorder: ViewModifier {
    let color: Color
    let radius: CGFloat
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: 1)
            )
            .shadow(color: color, radius: radius)
    }
}

// MARK: - Button Styles
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
    }
}

// MARK: - View Extensions
extension View {
    func neonBorder(
        color: Color = .green,
        radius: CGFloat = 2,
        cornerRadius: CGFloat = 15
    ) -> some View {
        modifier(NeonBorder(color: color, radius: radius, cornerRadius: cornerRadius))
    }
    
    func neonText(color: Color = .green) -> some View {
        modifier(NeonText(color: color))
    }
} 