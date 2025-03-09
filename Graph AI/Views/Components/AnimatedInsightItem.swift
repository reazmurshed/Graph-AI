import SwiftUI

struct AnimatedInsightItem: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let iconSize: CGFloat
    
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 15) {
            // Animación ocupando la mitad izquierda
            Image(systemName: icon)
                .font(.system(size: iconSize))
                .foregroundColor(color)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .opacity(isAnimating ? 1.0 : 0.7)
                .frame(width: 80) // Fijo el ancho para la animación
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever()) {
                        isAnimating = true
                    }
                }
            
            // Contenido derecho
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                Text(value)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
} 