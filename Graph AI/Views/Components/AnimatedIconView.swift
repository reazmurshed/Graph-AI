import SwiftUI

struct AnimatedIconView: View {
    let systemName: String
    let color: Color
    
    @State private var isAnimating = false
    @State private var glowOpacity = 0.0
    @State private var rotationAngle = 0.0
    
    var animation: Animation {
        switch systemName {
        case "chart.line.uptrend.xyaxis":
            return .easeInOut(duration: 2).repeatForever(autoreverses: true)
        case "waveform.path.ecg":
            return .spring(response: 0.5, dampingFraction: 0.5).repeatForever(autoreverses: true)
        case "chart.bar.fill":
            return .easeInOut(duration: 1.5).repeatForever(autoreverses: true)
        case "brain.head.profile":
            return .interpolatingSpring(stiffness: 5, damping: 3).repeatForever(autoreverses: false)
        default:
            return .default
        }
    }
    
    var body: some View {
        ZStack {
            // Background glow
            Image(systemName: systemName)
                .font(.system(size: 28))
                .foregroundColor(color)
                .opacity(glowOpacity)
                .blur(radius: 8)
            
            // Main icon
            Image(systemName: systemName)
                .font(.system(size: 24))
                .foregroundColor(color)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .rotationEffect(.degrees(rotationAngle))
        }
        .onAppear {
            withAnimation(animation) {
                isAnimating = true
                glowOpacity = 0.5
                rotationAngle = systemName == "brain.head.profile" ? 360 : 0
            }
        }
    }
} 