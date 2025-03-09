import SwiftUI

struct KeyInsightsView: View {
    let analysis: GraphAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Título
            Text("Key Insights")
                .font(.system(size: 28, weight: .bold)) // Tamaño 28 y negrita
                .foregroundColor(.white)
                .padding(.horizontal)
            
            // Grid de insights
            VStack(spacing: 16) {
                // Primera fila: Trend y Volume
                HStack(spacing: 16) {
                    makeInsightRow(
                        title: "Trend",
                        value: analysis.data.trend,
                        icon: "chart.line.uptrend.xyaxis",
                        emoji: getTrendEmoji(analysis.data.trend),
                        color: getTrendColor(analysis.data.trend)
                    )
                    
                    makeInsightRow(
                        title: "Volume",
                        value: getVolumeFromAnalysis(),
                        icon: "chart.bar.fill",
                        emoji: getVolumeEmoji(getVolumeFromAnalysis()),
                        color: getVolatilityColor(getVolumeFromAnalysis())
                    )
                }
                
                // Segunda fila: Volatility y Sentiment
                HStack(spacing: 16) {
                    makeInsightRow(
                        title: "Volatility",
                        value: analysis.riskLevel ?? "MEDIUM",
                        icon: "waveform.path.ecg",
                        emoji: getVolatilityEmoji(analysis.riskLevel),
                        color: getVolatilityColor(analysis.riskLevel)
                    )
                    
                    makeInsightRow(
                        title: "Sentiment",
                        value: analysis.marketMood ?? "NEUTRAL",
                        icon: "brain.head.profile",
                        emoji: getSentimentEmoji(analysis.marketMood),
                        color: getSentimentColor(analysis.marketMood)
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func makeInsightRow(title: String, value: String, icon: String, emoji: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .foregroundColor(.gray)
                .font(.subheadline)
            
            HStack {
                Text(value)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
                
                if title == "Trend" {
                    MiniChartView(trend: value)
                } else {
                    Text(emoji)
                        .font(.system(size: 24))
                }
            }
        }
        .padding()
        .background(color.opacity(0.15))
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
    }
    
    private func getVolumeFromAnalysis() -> String {
        if let volumeInsight = analysis.data.insights.first(where: { $0.lowercased().contains("volume") }) {
            if volumeInsight.lowercased().contains("high") {
                return "HIGH"
            } else if volumeInsight.lowercased().contains("low") {
                return "LOW"
            }
        }
        return analysis.data.volume ?? "MEDIUM"
    }
    
    private func getTrendEmoji(_ trend: String) -> String {
        switch trend.lowercased() {
        case let t where t.contains("bullish"): return "📈"
        case let t where t.contains("bearish"): return "📉"
        case let t where t.contains("neutral"): return "➡️"
        case let t where t.contains("consolidating"): return "📊"
        case let t where t.contains("sideways"): return "↔️"
        case let t where t.contains("ranging"): return "🔄"
        case let t where t.contains("breakout"): return "🚀"
        case let t where t.contains("breakdown"): return "💥"
        default: return "📊"
        }
    }
    
    private func getVolatilityEmoji(_ volatility: String?) -> String {
        switch (volatility ?? "").lowercased() {
        case let v where v.contains("explosive"): return "💣"
        case let v where v.contains("extreme"): return "⚡️"
        case let v where v.contains("high"): return "🌋"
        case let v where v.contains("elevated"): return "📊"
        case let v where v.contains("moderate"): return "〽️"
        case let v where v.contains("normal"): return "🌊"
        case let v where v.contains("low"): return "🌅"
        case let v where v.contains("calm"): return "🌊"
        case let v where v.contains("choppy"): return "🎢"
        case let v where v.contains("stable"): return "⚖️"
        default: return "📊"
        }
    }
    
    private func getVolumeEmoji(_ volume: String) -> String {
        switch volume.lowercased() {
        case let v where v.contains("surging"): return "🌊"
        case let v where v.contains("explosive"): return "💥"
        case let v where v.contains("high"): return "💪"
        case let v where v.contains("strong"): return "🚀"
        case let v where v.contains("above average"): return "📈"
        case let v where v.contains("average"): return "➡️"
        case let v where v.contains("moderate"): return "〽️"
        case let v where v.contains("low"): return "🤏"
        case let v where v.contains("weak"): return "💨"
        case let v where v.contains("declining"): return "📉"
        default: return "📊"
        }
    }
    
    private func getSentimentEmoji(_ sentiment: String?) -> String {
        switch (sentiment ?? "").lowercased() {
        case let s where s.contains("extremely bullish"): return "🤑"
        case let s where s.contains("bullish"): return "😎"
        case let s where s.contains("slightly bullish"): return "🙂"
        case let s where s.contains("extremely bearish"): return "😱"
        case let s where s.contains("bearish"): return "😰"
        case let s where s.contains("slightly bearish"): return "😕"
        case let s where s.contains("extreme fear"): return "😨"
        case let s where s.contains("fearful"): return "😟"
        case let s where s.contains("cautious"): return "🤔"
        case let s where s.contains("extreme greed"): return "🤩"
        case let s where s.contains("greedy"): return "😏"
        case let s where s.contains("optimistic"): return "😊"
        case let s where s.contains("neutral"): return "😐"
        default: return "🤔"
        }
    }
    
    private func getSentimentColor(_ sentiment: String?) -> Color {
        switch (sentiment ?? "").lowercased() {
        case let s where s.contains("extremely bullish"): return Color(hex: "00FF00")
        case let s where s.contains("bullish"): return Color(hex: "33FF33")
        case let s where s.contains("slightly bullish"): return Color(hex: "66FF66")
        case let s where s.contains("extremely bearish"): return Color(hex: "FF0000")
        case let s where s.contains("bearish"): return Color(hex: "FF3333")
        case let s where s.contains("slightly bearish"): return Color(hex: "FF6666")
        case let s where s.contains("extreme fear"): return Color(hex: "9933FF")
        case let s where s.contains("fearful"): return Color(hex: "B366FF")
        case let s where s.contains("cautious"): return Color(hex: "FFCC66")
        case let s where s.contains("extreme greed"): return Color(hex: "FF9900")
        case let s where s.contains("greedy"): return Color(hex: "FFB366")
        case let s where s.contains("optimistic"): return Color(hex: "66FF99")
        case let s where s.contains("neutral"): return Color(hex: "808080")
        default: return Color(hex: "808080") // grey
        }
    }
    
    private func getTrendColor(_ trend: String) -> Color {
        switch trend.lowercased() {
        case let t where t.contains("strongly bullish"): return Color(hex: "00FF00")
        case let t where t.contains("bullish"): return Color(hex: "33FF33")
        case let t where t.contains("slightly bullish"): return Color(hex: "66FF66")
        case let t where t.contains("strongly bearish"): return Color(hex: "FF0000")
        case let t where t.contains("bearish"): return Color(hex: "FF3333")
        case let t where t.contains("slightly bearish"): return Color(hex: "FF6666")
        case let t where t.contains("neutral"): return Color(hex: "808080")
        case let t where t.contains("consolidating"): return Color(hex: "66B2FF")
        case let t where t.contains("sideways"): return Color(hex: "B366FF")
        case let t where t.contains("ranging"): return Color(hex: "FFB366")
        default: return Color(hex: "808080") // grey
        }
    }
    
    private func getVolatilityColor(_ volatility: String?) -> Color {
        switch (volatility ?? "").lowercased() {
        case let v where v.contains("explosive"): return .red
        case let v where v.contains("extreme"): return Color(hex: "FF4444")
        case let v where v.contains("high"): return Color(hex: "FF6B6B")
        case let v where v.contains("elevated"): return Color(hex: "FF9999")
        case let v where v.contains("moderate"): return Color(hex: "FFB366")
        case let v where v.contains("normal"): return Color(hex: "66B2FF")
        case let v where v.contains("low"): return Color(hex: "99FF99")
        case let v where v.contains("calm"): return Color(hex: "66FF66")
        case let v where v.contains("choppy"): return Color(hex: "FFCC66")
        case let v where v.contains("stable"): return Color(hex: "66CC66")
        default: return Color(hex: "808080") // grey
        }
    }
}

