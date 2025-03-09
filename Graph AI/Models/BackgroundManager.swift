import SwiftUI

class BackgroundManager: ObservableObject {
    static let shared = BackgroundManager()
    
    @Published var selectedBackground: Backgrounds {
        didSet {
            UserDefaults.standard.set(selectedBackground.rawValue, forKey: "selectedBackground")
        }
    }
    
    init() {
        if let savedBackground = UserDefaults.standard.string(forKey: "selectedBackground"),
           let background = Backgrounds.allCases.first(where: { $0.rawValue == savedBackground }) {
            self.selectedBackground = background
        } else {
            self.selectedBackground = .default
        }
    }
    
    // Función helper para mostrar la imagen de fondo
    func backgroundView(for url: String) -> some View {
        GeometryReader { geo in
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: geo.size.width * 1.3,
                        height: geo.size.height * 1.3
                    )
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height / 2
                    )
                    .clipped()
            } placeholder: {
                Color(hex: "1A1A1A")
            }
        }
    }
    
    enum Backgrounds: String, CaseIterable {
        case `default` = "https://i.imgur.com/RnwFTGZ.png"
        case neonMarket = "https://images.unsplash.com/photo-1614028674026-a65e31bfd27c"
        case cryptoMatrix = "https://images.unsplash.com/photo-1516245834210-c4c142787335"
        case tradingDesk = "https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f"
        case blueCharts = "https://images.unsplash.com/photo-1559526324-4b87b5e36e44"
        case darkAnalytics = "https://images.unsplash.com/photo-1451187580459-43490279c0fa"
        case purpleTrading = "https://images.unsplash.com/photo-1550751827-4bd374c3f58b"
        case techWaves = "https://images.unsplash.com/photo-1551288049-bebda4e38f71"
        case cosmicView = "https://images.unsplash.com/photo-1462331940025-496dfbfc7564"
        case mountainTrader = "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b"
        
        var displayName: String {
            switch self {
            case .default: return "Default Theme"
            case .neonMarket: return "Neon Market"
            case .cryptoMatrix: return "Crypto Matrix"
            case .tradingDesk: return "Trading Desk"
            case .blueCharts: return "Blue Charts"
            case .darkAnalytics: return "Dark Analytics"
            case .purpleTrading: return "Purple Trading"
            case .techWaves: return "Tech Waves"
            case .cosmicView: return "Cosmic View"
            case .mountainTrader: return "Mountain Trader"
            }
        }
    }
} 