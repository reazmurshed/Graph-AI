import SwiftUI

struct TechnicalAnalysisView: View {
    let analysis: GraphAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Technical Analysis")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal)
            
            VStack(spacing: 5) {
                // Trend Analysis Section
                DisclosureSection(
                    title: "Trend Analysis",
                    icon: "chart.line.uptrend.xyaxis",
                    content: formatTrendAnalysis(from: analysis)
                )
                .font(.system(size: 20)) // Add font size modifier here
                
                // Support & Resistance Section
                DisclosureSection(
                    title: "Support & Resistance",
                    icon: "arrow.up.and.down",
                    content: formatSupportResistance(from: analysis)
                )
                .font(.system(size: 20)) // Add font size modifier here
                
                // Indicators Section
                DisclosureSection(
                    title: "Technical Indicators",
                    icon: "gauge.with.needle",
                    content: formatIndicators(from: analysis)
                )
                .font(.system(size: 20)) // Add font size modifier here
                
                // Volume Analysis
                DisclosureSection(
                    title: "Volume Analysis",
                    icon: "chart.bar.fill",
                    content: formatVolumeAnalysis(from: analysis)
                )
                .font(.system(size: 20)) // Add font size modifier here
                
                // Pattern Recognition
                DisclosureSection(
                    title: "Pattern Recognition",
                    icon: "square.3.layers.3d",
                    content: formatPatterns(from: analysis)
                )
                .font(.system(size: 20)) // Add font size modifier here
            }
        }
    }
    
    private func formatTrendAnalysis(from analysis: GraphAnalysis) -> String {
        guard let technicalAnalysis = try? JSONSerialization.jsonObject(with: analysis.analysisText.data(using: .utf8) ?? Data(), options: []) as? [String: Any],
              let trendAnalysis = technicalAnalysis["technicalAnalysis"] as? [String: Any],
              let trend = trendAnalysis["trendAnalysis"] as? [String: Any] else {
            return "No trend analysis available"
        }
        
        return """
        Primary Trend:
        \(trend["primary"] as? String ?? "")
        
        Trend Strength:
        \(trend["strength"] as? String ?? "")
        """
    }
    
    private func formatSupportResistance(from analysis: GraphAnalysis) -> String {
        guard let technicalAnalysis = try? JSONSerialization.jsonObject(with: analysis.analysisText.data(using: .utf8) ?? Data(), options: []) as? [String: Any],
              let supportResistance = technicalAnalysis["technicalAnalysis"] as? [String: Any],
              let levels = supportResistance["supportResistance"] as? [String: Any] else {
            return "No support/resistance levels available"
        }
        
        let supports = (levels["supports"] as? [String])?.joined(separator: "\n• ") ?? ""
        let resistances = (levels["resistances"] as? [String])?.joined(separator: "\n• ") ?? ""
        
        return """
        Support Levels:
        • \(supports)
        
        Resistance Levels:
        • \(resistances)
        """
    }
    
    private func formatIndicators(from analysis: GraphAnalysis) -> String {
        guard let technicalAnalysis = try? JSONSerialization.jsonObject(with: analysis.analysisText.data(using: .utf8) ?? Data(), options: []) as? [String: Any],
              let indicators = (technicalAnalysis["technicalAnalysis"] as? [String: Any])?["indicators"] as? [String: Any] else {
            return "No indicator analysis available"
        }
        
        return """
        RSI:
        \(indicators["rsi"] as? String ?? "")
        
        MACD:
        \(indicators["macd"] as? String ?? "")
        
        Moving Averages:
        \(indicators["movingAverages"] as? String ?? "")
        """
    }
    
    private func formatVolumeAnalysis(from analysis: GraphAnalysis) -> String {
        guard let technicalAnalysis = try? JSONSerialization.jsonObject(with: analysis.analysisText.data(using: .utf8) ?? Data(), options: []) as? [String: Any],
              let volume = (technicalAnalysis["technicalAnalysis"] as? [String: Any])?["volume"] as? String else {
            return "No volume analysis available"
        }
        
        return volume
    }
    
    private func formatPatterns(from analysis: GraphAnalysis) -> String {
        guard let technicalAnalysis = try? JSONSerialization.jsonObject(with: analysis.analysisText.data(using: .utf8) ?? Data(), options: []) as? [String: Any],
              let patterns = (technicalAnalysis["technicalAnalysis"] as? [String: Any])?["patterns"] as? [String] else {
            return "No patterns detected"
        }
        
        return patterns.map { "• " + $0 }.joined(separator: "\n")
    }
}

struct IndicatorView: View {
    let title: String
    let content: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: onTap) {
                HStack {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isSelected ? 90 : 0))
                }
            }
            
            if isSelected {
                Text(content)
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .padding(.top, 5)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
} 
