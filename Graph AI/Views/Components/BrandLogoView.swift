import SwiftUI

struct BrandLogoView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60))
                .foregroundColor(Constants.accentColor)
            
            Text("Graph AI")
                .font(.system(size: 24, weight: .bold))
                .italic()
                .foregroundColor(.white)
        }
        .padding()
        .background(Color(hex: "1A1A1A"))
    }
} 