import SwiftUI

struct MarketPulseView: View {
    let analysis: GraphAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Market Pulse")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                // Usamos los campos correctos del modelo GraphAnalysis
                insightRow(
                    title: "Trend",
                    value: analysis.data.trend,
                    icon: "chart.line.uptrend.xyaxis"
                )
                
                insightRow(
                    title: "Market Mood",
                    value: analysis.marketMood ?? "Neutral",
                    icon: "brain.head.profile"
                )
                
                insightRow(
                    title: "Risk Level",
                    value: analysis.riskLevel ?? "Medium",
                    icon: "gauge.with.needle"
                )
                
                if let sentiment = analysis.sentiment {
                    insightRow(
                        title: "Sentiment",
                        value: sentiment,
                        icon: "heart.fill"
                    )
                }
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(15)
        }
        .padding(.horizontal)
    }
    
    private func insightRow(title: String, value: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)
                .font(.system(size: 20))
            
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                Text(value)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            Spacer()
        }
    }
} 