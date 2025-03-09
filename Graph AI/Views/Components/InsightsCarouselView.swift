import SwiftUI

struct InsightsCarouselView: View {
    let insights: [String]
    @State private var currentIndex = 0
    @State private var timer: Timer?
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(insights.enumerated()), id: \.1) { index, insight in
                InsightCardView(insight: insight)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .onAppear {
            startAutoScroll()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startAutoScroll() {
        guard !insights.isEmpty else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % insights.count
            }
        }
    }
}

struct InsightCardView: View {
    let insight: String
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Text(insight)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.3))
                )
                .padding(.horizontal)
                .scaleEffect(isAnimating ? 1.02 : 1)
                .animation(
                    Animation.easeInOut(duration: 1)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    InsightsCarouselView(insights: [
        "Bullish trend with strong momentum",
        "Volume increasing on breakouts",
        "Key resistance at 1.2500"
    ])
    .preferredColorScheme(.dark)
} 