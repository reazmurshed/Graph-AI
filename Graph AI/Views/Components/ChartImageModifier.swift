import SwiftUI

struct ChartImageStyle: ViewModifier {
    @State private var rotationAngles: [Double] = Array(repeating: 0, count: 4)
    @State private var bouncing = false
    
    private let shadowConfigs: [(size: CGFloat, offset: (CGFloat, CGFloat), blur: CGFloat, opacity: (CGFloat, CGFloat), duration: Double)] = [
        (0.85, (20, 20), 30, (0.5, 0.2), 8),
        (0.80, (-20, -20), 35, (0.4, 0.1), 10),
        (0.75, (20, -20), 40, (0.3, 0.05), 12),
        (0.70, (-20, 20), 45, (0.2, 0.0), 14)
    ]
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack {
                // Rotating shadows
                ForEach(0..<shadowConfigs.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.green.opacity(shadowConfigs[index].opacity.0),
                                    Color.green.opacity(shadowConfigs[index].opacity.1),
                                    Color.green.opacity(0.0)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(
                            width: geometry.size.width * shadowConfigs[index].size,
                            height: geometry.size.width * shadowConfigs[index].size
                        )
                        .offset(
                            x: shadowConfigs[index].offset.0,
                            y: shadowConfigs[index].offset.1
                        )
                        .blur(radius: shadowConfigs[index].blur)
                        .rotationEffect(.degrees(rotationAngles[index]))
                }
                
                // Main content
                content
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .cornerRadius(16)
                    .offset(y: bouncing ? -5 : 5)
            }
        }
        .frame(maxHeight: UIScreen.main.bounds.height * 0.36)
        .padding(.horizontal)
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Bouncing animation
        withAnimation(
            Animation
                .easeInOut(duration: 2.5)
                .repeatForever(autoreverses: true)
        ) {
            bouncing = true
        }
        
        // Rotation animations
        for i in 0..<shadowConfigs.count {
            withAnimation(
                .linear(duration: shadowConfigs[i].duration)
                .repeatForever(autoreverses: false)
            ) {
                rotationAngles[i] = 360
            }
        }
    }
}

extension Image {
    func chartImageStyle() -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
            .modifier(ChartImageStyle())
    }
} 