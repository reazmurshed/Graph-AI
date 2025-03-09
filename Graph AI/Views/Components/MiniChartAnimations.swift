import SwiftUI

struct MiniChartView: View {
    let trend: String
    @State private var phase: CGFloat = 0
    
    var body: some View {
        switch trend.lowercased() {
        case let t where t.contains("bull"):
            BullishMiniChart()
        case let t where t.contains("bear"):
            BearishMiniChart()
        default:
            NeutralMiniChart()
        }
    }
}

struct BullishMiniChart: View {
    @State private var progress: CGFloat = 0
    
    var body: some View {
        Canvas { context, size in
            // Dibujar línea principal
            let path = Path { p in
                p.move(to: CGPoint(x: 0, y: size.height * 0.8))
                p.addCurve(
                    to: CGPoint(x: size.width, y: size.height * 0.2),
                    control1: CGPoint(x: size.width * 0.4, y: size.height * 0.8),
                    control2: CGPoint(x: size.width * 0.6, y: size.height * 0.2)
                )
            }
            
            // Aplicar el trazo con gradiente
            context.stroke(
                path.trimmedPath(from: 0, to: progress),
                with: .linearGradient(
                    .init(colors: [.green.opacity(0.5), .green]),
                    startPoint: .init(x: 0, y: size.height),
                    endPoint: .init(x: size.width, y: 0)
                ),
                lineWidth: 3
            )
            
            // Añadir punto brillante al final
            if progress > 0.9 {
                context.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width - 5,
                        y: size.height * 0.2 - 5,
                        width: 10,
                        height: 10
                    )),
                    with: .color(.green)
                )
            }
        }
        .frame(width: 40, height: 40)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                progress = 1.0
            }
        }
    }
}

struct BearishMiniChart: View {
    @State private var progress: CGFloat = 0
    
    var body: some View {
        Canvas { context, size in
            // Dibujar línea principal
            let path = Path { p in
                p.move(to: CGPoint(x: 0, y: size.height * 0.2))
                p.addCurve(
                    to: CGPoint(x: size.width, y: size.height * 0.8),
                    control1: CGPoint(x: size.width * 0.4, y: size.height * 0.2),
                    control2: CGPoint(x: size.width * 0.6, y: size.height * 0.8)
                )
            }
            
            // Aplicar el trazo con gradiente
            context.stroke(
                path.trimmedPath(from: 0, to: progress),
                with: .linearGradient(
                    .init(colors: [.red.opacity(0.5), .red]),
                    startPoint: .init(x: 0, y: 0),
                    endPoint: .init(x: size.width, y: size.height)
                ),
                lineWidth: 3
            )
            
            // Añadir punto brillante al final
            if progress > 0.9 {
                context.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width - 5,
                        y: size.height * 0.8 - 5,
                        width: 10,
                        height: 10
                    )),
                    with: .color(.red)
                )
            }
        }
        .frame(width: 40, height: 40)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                progress = 1.0
            }
        }
    }
}

struct NeutralMiniChart: View {
    @State private var progress: CGFloat = 0
    @State private var phase: CGFloat = 0
    
    var body: some View {
        Canvas { context, size in
            // Dibujar línea principal
            let path = Path { p in
                p.move(to: CGPoint(x: 0, y: size.height * 0.5))
                for x in stride(from: 0, through: size.width, by: 2) {
                    let y = sin((x / size.width * .pi * 2 + phase) * 2) * 10 + size.height * 0.5
                    p.addLine(to: CGPoint(x: x, y: y))
                }
            }
            
            // Aplicar el trazo con gradiente
            context.stroke(
                path.trimmedPath(from: 0, to: progress),
                with: .linearGradient(
                    .init(colors: [.yellow.opacity(0.5), .yellow]),
                    startPoint: .init(x: 0, y: size.height * 0.5),
                    endPoint: .init(x: size.width, y: size.height * 0.5)
                ),
                lineWidth: 3
            )
        }
        .frame(width: 40, height: 40)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                progress = 1.0
            }
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
} 