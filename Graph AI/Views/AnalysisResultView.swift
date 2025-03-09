import SwiftUI

struct AnalysisResultView: View {
    let analysis: GraphAnalysis
    let image: UIImage
    let onBack: () -> Void
    
    @State private var imageScale: CGFloat = 0.4
    @State private var selectedSection: AnalysisSection = .keyInsights
    @State private var glowColor = Color.green
    @State private var rotationAngles: [Double] = Array(repeating: 0, count: 8)
    
    // Valores precalculados para las sombras
    private let shadowConfigs: [(opacity: (Double, Double), size: Double, offset: (Double, Double), blur: Double, duration: Double)] = (0..<8).map { _ in (
        opacity: (Double.random(in: 0.2...0.3), Double.random(in: 0.05...0.1)),
        size: Double.random(in: 0.8...0.9),
        offset: (Double.random(in: -10...10), Double.random(in: -10...10)),
        blur: Double.random(in: 15...25),
        duration: Double.random(in: 3...6)
    )}
    
    enum AnalysisSection: String, CaseIterable {
        case keyInsights = "Key Insights"
        case gamePlan = "Game Plan"
        case technicalAnalysis = "Technical Analysis"
    }
    
    var body: some View {
        ZStack {
            // Fondo
            ZStack {
                Color(hex: "1A1A1A")
                NebulaView()
                    .opacity(0.3)
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Título y botón de cerrar en la misma línea
                    HStack {
                        Button(action: onBack) {
                            Image(systemName: "xmark")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(Color.green)
                        }
                        
                        Spacer()
                        
                        Text("Graph AI")
                            .font(.system(size: 46, weight: .bold))
                            .italic()
                            .foregroundColor(.white)
                            .shadow(color: .green.opacity(0.3), radius: 10)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, UIScreen.main.bounds.height * 0.03)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.05) // 5% de espacio adicional después del título
                    
                    // Imagen y sombras
                    ZStack {
                        // Múltiples sombras rotatorias
                        ForEach(0..<8) { index in
                            Circle()
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
                                    width: UIScreen.main.bounds.width * shadowConfigs[index].size,
                                    height: UIScreen.main.bounds.width * shadowConfigs[index].size
                                )
                                .offset(
                                    x: shadowConfigs[index].offset.0,
                                    y: shadowConfigs[index].offset.1
                                )
                                .blur(radius: shadowConfigs[index].blur)
                                .rotationEffect(.degrees(rotationAngles[index]))
                                .onAppear {
                                    withAnimation(
                                        .linear(duration: shadowConfigs[index].duration)
                                        .repeatForever(autoreverses: false)
                                    ) {
                                        rotationAngles[index] = 360
                                    }
                                }
                        }
                        
                        Image(uiImage: image)
                            .chartImageStyle()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.vertical, 20)  // Aumentado el padding vertical
                    
                    if analysis.isChart {
                        // Añadir espacio extra entre la imagen y el texto
                        Spacer()
                            .frame(height: 40)  // Espacio adicional
                        
                        // Secciones de análisis
                        VStack(spacing: 20) {
                            KeyInsightsView(analysis: analysis)
                            GamePlanView(analysis: analysis)
                            TechnicalAnalysisView(analysis: analysis)
                        }
                        .padding(.horizontal, 10)
                        
                        Text("This is not trading advice")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                            .padding(.bottom, 30)
                    } else {
                        Text(analysis.humorousComment ?? "")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(30)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(15)
                            .padding(.horizontal, 20)
                            .padding(.top, UIScreen.main.bounds.height * 0.03) // 3% de espacio adicional arriba
                            .padding(.bottom, UIScreen.main.bounds.height * 0.03) // 3% de espacio adicional abajo
                    }
                }
            }
        }
        .navigationBarHidden(true) // Ocultar completamente la barra de navegación
    }
    
    // Helper function to convert sentiment to mood emoji
    private func getMoodEmoji(_ sentiment: String?) -> String {
        guard let sentiment = sentiment?.lowercased() else { return "😐" }
        switch sentiment {
        case _ where sentiment.contains("bullish"): return "😊 Optimistic"
        case _ where sentiment.contains("bearish"): return "😔 Concerned"
        case _ where sentiment.contains("neutral"): return "😐 Neutral"
        case _ where sentiment.contains("strong"): return "🤩 Euphoric"
        case _ where sentiment.contains("weak"): return "😟 Worried"
        default: return "🤔 Analyzing"
        }
    }
    
    private func getTrendColor(_ trend: String) -> Color {
        switch trend.lowercased() {
        case _ where trend.contains("bullish"): return .green
        case _ where trend.contains("bearish"): return .red
        default: return .yellow
        }
    }
    
    private func getVolatilityColor(_ risk: String?) -> Color {
        guard let risk = risk?.lowercased() else { return .orange }
        switch risk {
        case _ where risk.contains("high"): return .red
        case _ where risk.contains("low"): return .green
        default: return .orange
        }
    }
}

struct InsightItem: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .foregroundColor(.gray)
                .font(.subheadline)
            
            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct DisclosureSection: View {
    let title: String
    let icon: String
    let content: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Label(title, systemImage: icon)
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
            }
            
            if isExpanded {
                Text(content)
                    .foregroundColor(.white)
                    .font(.body)
                    .padding(.top, 5)
            }
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

// Nebula Animation Background
struct NebulaView: View {
    @State private var phase = 0.0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                phase = now.remainder(dividingBy: 10)
                
                context.addFilter(.blur(radius: 70))
                
                context.drawLayer { ctx in
                    for i in 0...10 {
                        let color = i % 2 == 0 ? Color.blue : Color.purple
                        ctx.fill(
                            Path(ellipseIn: CGRect(x: size.width/2 + cos(phase + Double(i)) * 50,
                                                  y: size.height/2 + sin(phase + Double(i)) * 50,
                                                  width: 100,
                                                  height: 100)),
                            with: .color(color.opacity(0.3))
                        )
                    }
                }
            }
        }
    }
}

// Extensión para el borde neón verde
extension View {
    func neonBorder(color: Color = .green, radius: CGFloat = 2) -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(color, lineWidth: 1)
            )
            .shadow(color: color, radius: radius)
    }
}

@MainActor
private func showNotification(message: String, instruction: String) {
    let banner = UIView()
    banner.backgroundColor = UIColor(white: 0.1, alpha: 0.95)
    banner.layer.cornerRadius = 12
    banner.clipsToBounds = true
    
    let label = UILabel()
    label.text = message
    label.textColor = .white
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textAlignment = .center
    
    banner.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        label.leadingAnchor.constraint(equalTo: banner.leadingAnchor, constant: 16),
        label.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -16),
        label.topAnchor.constraint(equalTo: banner.topAnchor, constant: 16),
        label.bottomAnchor.constraint(equalTo: banner.bottomAnchor, constant: -16)
    ])
    
    guard let window = UIApplication.shared.windows.first else { return }
    window.addSubview(banner)
    
    banner.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        banner.centerXAnchor.constraint(equalTo: window.centerXAnchor),
        banner.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 20),
        banner.widthAnchor.constraint(lessThanOrEqualTo: window.widthAnchor, constant: -32)
    ])
    
    banner.transform = CGAffineTransform(translationX: 0, y: -100)
    
    UIView.animate(withDuration: 0.3) {
        banner.transform = .identity
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        UIView.animate(withDuration: 0.3) {
            banner.transform = CGAffineTransform(translationX: 0, y: -100)
            banner.alpha = 0
        } completion: { _ in
            banner.removeFromSuperview()
        }
    }
} 
