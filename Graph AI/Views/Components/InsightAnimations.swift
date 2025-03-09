import SwiftUI

enum InsightAnimation: String {
    case trend = "trend"
    case volatility = "volatility"
    case volume = "volume"
    case sentiment = "sentiment"
    
    var systemImage: String {
        switch self {
        case .trend:
            return "chart.line.uptrend.xyaxis"
        case .volatility:
            return "waveform.path.ecg"
        case .volume:
            return "chart.bar.fill"
        case .sentiment:
            return "brain.head.profile"
        }
    }
    
    var color: Color {
        switch self {
        case .trend:
            return .green
        case .volatility:
            return .orange
        case .volume:
            return .pink
        case .sentiment:
            return .blue
        }
    }
}

struct BullishAnimation: View {
    @State private var scale: CGFloat = 1
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 0
    @State private var candleOffset: CGFloat = 50
    
    var body: some View {
        ZStack {
            // Fondo de tendencia
            ForEach(0..<3) { index in
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 70))
                    .foregroundColor(.green.opacity(0.3))
                    .offset(x: CGFloat(index * 20) - 20, y: offset)
                    .opacity(0.5)
            }
            
            // Velas alcistas
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 10, height: 30 + CGFloat(index * 10))
                        .offset(y: candleOffset)
                }
            }
            
            // Flecha principal
            Image(systemName: "arrow.up.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
                .scaleEffect(scale)
                .opacity(opacity)
                .overlay(
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .offset(y: -20)
                        .opacity(opacity)
                )
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).repeatForever(autoreverses: true)) {
                scale = 1.2
                offset = -20
                opacity = 1
                candleOffset = 0
            }
        }
    }
}

struct BearishAnimation: View {
    @State private var scale: CGFloat = 1
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 0
    @State private var candleOffset: CGFloat = -50
    
    var body: some View {
        ZStack {
            // Fondo de tendencia
            ForEach(0..<3) { index in
                Image(systemName: "chart.line.downtrend.xyaxis")
                    .font(.system(size: 70))
                    .foregroundColor(.red.opacity(0.3))
                    .offset(x: CGFloat(index * 20) - 20, y: offset)
                    .opacity(0.5)
            }
            
            // Velas bajistas
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 10, height: 30 + CGFloat((2-index) * 10))
                        .offset(y: candleOffset)
                }
            }
            
            // Flecha principal
            Image(systemName: "arrow.down.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
                .scaleEffect(scale)
                .opacity(opacity)
                .overlay(
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .offset(y: 20)
                        .opacity(opacity)
                )
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).repeatForever(autoreverses: true)) {
                scale = 1.2
                offset = 20
                opacity = 1
                candleOffset = 0
            }
        }
    }
}

struct NeutralAnimation: View {
    @State private var rotation: Double = 0
    @State private var opacity: Double = 0
    @State private var lineOffset: CGFloat = -50
    
    var body: some View {
        ZStack {
            // Líneas de consolidación
            VStack(spacing: 15) {
                ForEach(0..<2) { index in
                    Rectangle()
                        .fill(Color.yellow.opacity(0.5))
                        .frame(height: 2)
                        .offset(x: lineOffset)
                }
            }
            
            // Patrón de consolidación
            ForEach(0..<4) { index in
                Image(systemName: "arrow.left.and.right")
                    .font(.system(size: 40))
                    .foregroundColor(.yellow)
                    .rotationEffect(.degrees(Double(index) * 90))
                    .opacity(opacity)
            }
            
            // Indicador central
            Image(systemName: "equal.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
                .rotationEffect(.degrees(rotation))
                .opacity(opacity)
                .overlay(
                    Image(systemName: "clock.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .opacity(opacity)
                )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                rotation = 360
                opacity = 1
                lineOffset = 50
            }
        }
    }
}

struct VolatilityAnimation: View {
    @State private var scale: CGFloat = 1
    @State private var wiggle: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Ondas de volatilidad
            ForEach(0..<3) { index in
                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 50))
                    .foregroundColor(.purple.opacity(0.3))
                    .offset(x: wiggle + CGFloat(index * 20))
            }
            
            // Indicador de volatilidad
            Image(systemName: "bolt.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.purple)
                .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                scale = 1.2
                wiggle = 20
            }
        }
    }
}

struct StrongBullishAnimation: View {
    @State private var scale: CGFloat = 1
    @State private var offset: CGFloat = 0
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // Múltiples velas verdes ascendentes
            ForEach(0..<5) { index in
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 12, height: 40 + CGFloat(index * 15))
                    .offset(x: CGFloat(index * 20) - 40, y: -offset)
            }
            
            // Cohete hacia arriba
            Image(systemName: "arrow.up.forward.circle.fill")
                .font(.system(size: 70))
                .foregroundColor(.green)
                .rotationEffect(.degrees(-45))
                .scaleEffect(scale)
                .overlay(
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .offset(y: 20)
                        .rotationEffect(.degrees(rotation))
                )
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5).repeatForever()) {
                scale = 1.3
                offset = 30
                rotation = 360
            }
        }
    }
}

struct WeakBullishAnimation: View {
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 0.5
    
    var body: some View {
        ZStack {
            // Línea de tendencia suave
            Path { path in
                path.move(to: CGPoint(x: 0, y: 50))
                path.addCurve(
                    to: CGPoint(x: 100, y: 30),
                    control1: CGPoint(x: 30, y: 45),
                    control2: CGPoint(x: 70, y: 35)
                )
            }
            .stroke(Color.green, style: StrokeStyle(lineWidth: 3, dash: [5, 5]))
            
            // Pequeñas flechas ascendentes
            ForEach(0..<3) { index in
                Image(systemName: "arrow.up.circle")
                    .font(.system(size: 30))
                    .foregroundColor(.green)
                    .offset(x: CGFloat(index * 30) - 30, y: offset)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                offset = -10
                opacity = 1
            }
        }
    }
}

struct StrongBearishAnimation: View {
    @State private var scale: CGFloat = 1
    @State private var offset: CGFloat = 0
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // Múltiples velas rojas descendentes
            ForEach(0..<5) { index in
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 12, height: 40 + CGFloat((4-index) * 15))
                    .offset(x: CGFloat(index * 20) - 40, y: offset)
            }
            
            // Caída libre
            Image(systemName: "arrow.down.forward.circle.fill")
                .font(.system(size: 70))
                .foregroundColor(.red)
                .rotationEffect(.degrees(45))
                .scaleEffect(scale)
                .overlay(
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                        .offset(y: -20)
                        .rotationEffect(.degrees(rotation))
                )
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5).repeatForever()) {
                scale = 1.3
                offset = 30
                rotation = 360
            }
        }
    }
}

struct BreakoutAnimation: View {
    @State private var scale: CGFloat = 1
    @State private var lineOffset: CGFloat = 0
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            // Línea de resistencia
            Rectangle()
                .fill(Color.white.opacity(0.3))
                .frame(height: 2)
            
            // Explosión de breakout
            ForEach(0..<8) { index in
                Image(systemName: "sparkles")
                    .font(.system(size: 30))
                    .foregroundColor(.yellow)
                    .rotationEffect(.degrees(Double(index) * 45))
                    .offset(y: -lineOffset)
                    .opacity(opacity)
            }
            
            // Flecha de ruptura
            Image(systemName: "arrow.up.forward.square.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
                .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).repeatForever()) {
                scale = 1.2
                lineOffset = 30
                opacity = 1
            }
        }
    }
}

struct HighVolatilityAnimation: View {
    @State private var offset: CGFloat = 0
    @State private var scale: CGFloat = 1
    
    var body: some View {
        ZStack {
            // Ondas violentas
            ForEach(0..<3) { index in
                Image(systemName: "waveform.path.ecg.rectangle")
                    .font(.system(size: 60))
                    .foregroundColor(.red.opacity(0.3))
                    .offset(x: offset + CGFloat(index * 20))
            }
            
            // Relámpagos
            ForEach(0..<2) { index in
                Image(systemName: "bolt.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.yellow)
                    .offset(x: CGFloat(index * 40) - 20)
                    .scaleEffect(scale)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                offset = 20
                scale = 1.2
            }
        }
    }
}

struct LowVolatilityAnimation: View {
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Ondas suaves
            ForEach(0..<3) { index in
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 50))
                    path.addCurve(
                        to: CGPoint(x: 100, y: 50),
                        control1: CGPoint(x: 25, y: 45 + CGFloat(index * 2)),
                        control2: CGPoint(x: 75, y: 55 - CGFloat(index * 2))
                    )
                }
                .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                .offset(x: offset)
            }
            
            // Indicador de calma
            Image(systemName: "moon.stars.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue)
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: true)) {
                offset = 20
            }
        }
    }
}

enum MarketState {
    case strongBullish
    case weakBullish
    case strongBearish
    case weakBearish
    case neutral
    case breakout
    case breakdown
    case highVolatility
    case lowVolatility
    case consolidation
    case ranging
    
    var animation: some View {
        switch self {
        case .strongBullish:
            return AnyView(StrongBullishAnimation())
        case .weakBullish:
            return AnyView(WeakBullishAnimation())
        case .strongBearish:
            return AnyView(StrongBearishAnimation())
        case .weakBearish:
            return AnyView(BearishAnimation())
        case .neutral:
            return AnyView(NeutralAnimation())
        case .breakout:
            return AnyView(BreakoutAnimation())
        case .breakdown:
            return AnyView(BreakoutAnimation().rotationEffect(.degrees(180)))
        case .highVolatility:
            return AnyView(HighVolatilityAnimation())
        case .lowVolatility:
            return AnyView(LowVolatilityAnimation())
        case .consolidation:
            return AnyView(NeutralAnimation())
        case .ranging:
            return AnyView(VolatilityAnimation())
        }
    }
} 