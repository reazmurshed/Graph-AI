import SwiftUI

struct LogoDisplayView: View {
    var body: some View {
        ZStack {
            Color(hex: "1A1A1A")
            
            VStack(spacing: 8) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 60))
                    .foregroundColor(Constants.accentColor)
                
                Text("Graph AI")
                    .font(.system(size: 24, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    LogoDisplayView()
} 