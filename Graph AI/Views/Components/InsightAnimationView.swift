import SwiftUI

struct InsightAnimationView: View {
    let type: InsightType
    let value: String
    
    enum InsightType {
        case trend
        case volume
        case volatility
        case sentiment
    }
    
    var body: some View {
        ZStack {
            switch type {
            case .trend:
                Text(getTrendEmoji(value))
                    .font(.system(size: 24))
            case .volume:
                VolumeAnimationView(value: value)
                    .frame(width: 24, height: 24)
            case .volatility:
                VolatilityAnimationView(value: value)
                    .frame(width: 24, height: 24)
            case .sentiment:
                SentimentAnimationView(value: value)
                    .frame(width: 24, height: 24)
            }
        }
    }
    
    private func getTrendEmoji(_ trend: String) -> String {
        switch trend.lowercased() {
        case _ where trend.contains("bullish"): return "📈"
        case _ where trend.contains("bearish"): return "📉"
        default: return "📊"
        }
    }
}

// Separamos cada vista en su propia estructura
private struct VolumeAnimationView: View {
    let value: String
    @State private var progress: CGFloat = 0
    @State private var color: Color = .yellow
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.3))
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: geometry.size.width * progress)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: progress)
            }
            .onAppear {
                switch value.lowercased() {
                case "surging":
                    progress = 1.0
                    color = .red
                case "strong":
                    progress = 0.8
                    color = .orange
                case "average":
                    progress = 0.5
                    color = .yellow
                default:
                    progress = 0.3
                    color = .green
                }
            }
        }
    }
}

private struct VolatilityAnimationView: View {
    let value: String
    @State private var phase: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let midHeight = height / 2
                
                path.move(to: CGPoint(x: 0, y: midHeight))
                
                for x in stride(from: 0, through: width, by: 2) {
                    let multiplier: CGFloat
                    switch value.lowercased() {
                    case "explosive": multiplier = 1.0
                    case "high": multiplier = 0.8
                    case "medium": multiplier = 0.5
                    default: multiplier = 0.2
                    }
                    
                    let y = midHeight + sin(x/10 + phase) * (height/3) * multiplier
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(getVolatilityColor(value), lineWidth: 2)
            .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: phase)
            .onAppear {
                phase = .pi * 2
            }
        }
    }
    
    private func getVolatilityColor(_ value: String) -> Color {
        switch value.lowercased() {
        case "explosive": return .red
        case "high": return .orange
        case "medium": return .yellow
        default: return .green
        }
    }
}

private struct SentimentAnimationView: View {
    let value: String
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(getSentimentColor(value))
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
            
            getSentimentSymbol(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                scale = getSentimentScale(value)
                rotation = getSentimentRotation(value)
            }
        }
    }
    
    private func getSentimentColor(_ value: String) -> Color {
        switch value.lowercased() {
        case "greedy", "bullish": return .green
        case "fearful", "bearish": return .red
        default: return .yellow
        }
    }
    
    private func getSentimentSymbol(_ value: String) -> Text {
        switch value.lowercased() {
        case "greedy", "bullish": return Text("↗")
        case "fearful", "bearish": return Text("↘")
        default: return Text("→")
        }
    }
    
    private func getSentimentScale(_ value: String) -> CGFloat {
        switch value.lowercased() {
        case "greedy", "fearful": return 1.2
        case "bullish", "bearish": return 1.1
        default: return 1.0
        }
    }
    
    private func getSentimentRotation(_ value: String) -> Double {
        switch value.lowercased() {
        case "greedy", "bullish": return 45
        case "fearful", "bearish": return -45
        default: return 0
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        InsightAnimationView(type: .trend, value: "BULLISH")
        InsightAnimationView(type: .volume, value: "SURGING")
        InsightAnimationView(type: .volatility, value: "EXPLOSIVE")
        InsightAnimationView(type: .sentiment, value: "GREEDY")
    }
    .padding()
    .background(Color.black)
} 