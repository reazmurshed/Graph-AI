import SwiftUI

enum Constants {
    static let accentColor = Color(hex: "2E7D32")
    static let backgroundColor = Color(hex: "1A1A1A")
    
    enum API {
        static let baseURL = "https://api.openai.com"
    }
    
    enum Animation {
        static let buttonScale = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.6)
        static let transition = AnyTransition.opacity.combined(with: .slide)
    }
} 
