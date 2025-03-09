import Foundation

struct GraphAnalysis: Codable, Equatable {
    let analysisText: String
    let data: GraphData
    let isChart: Bool
    let humorousComment: String?
    let gamePlan: String?
    let emoji: String?
    let sentiment: String?
    let marketMood: String?
    let riskLevel: String?
    let imageData: Data?
    
    struct GraphData: Codable, Equatable {
        let type: String
        let xAxis: String
        let yAxis: String
        let trend: String
        let insights: [String]
        let recommendations: [String]
        let volume: String?
    }
    
    static func notAChart(withHumor humor: String) -> GraphAnalysis {
        return GraphAnalysis(
            analysisText: humor,
            data: GraphData(
                type: "Not a chart",
                xAxis: "",
                yAxis: "",
                trend: "",
                insights: [],
                recommendations: [],
                volume: nil
            ),
            isChart: false,
            humorousComment: humor,
            gamePlan: nil,
            emoji: nil,
            sentiment: nil,
            marketMood: nil,
            riskLevel: nil,
            imageData: nil
        )
    }
    
    static func defaultAnalysis(with content: String) -> GraphAnalysis {
        return GraphAnalysis(
            analysisText: content,
            data: GraphData(
                type: "Chart",
                xAxis: "Time",
                yAxis: "Value",
                trend: content.lowercased().contains("upward") || content.lowercased().contains("increasing") ? "BULLISH" : "BEARISH",
                insights: [content],
                recommendations: ["Analyze the market carefully"],
                volume: nil
            ),
            isChart: true,
            humorousComment: nil,
            gamePlan: """
                TRADING STRATEGY:
                
                Overview:
                Market analysis in progress. Please review the chart carefully.
                
                Entry Points:
                • Wait for clear confirmation signals
                • Look for high-probability setups
                
                Risk Management:
                • Use appropriate position sizing
                • Set clear stop losses
                • Follow your trading plan
                
                Target Levels:
                • Set realistic profit targets
                • Consider market conditions
                
                Time Horizon:
                • Adapt to market conditions
                """,
            emoji: "📊",
            sentiment: content.lowercased().contains("bullish") ? "BULLISH" : "BEARISH",
            marketMood: content.lowercased().contains("bullish") ? "BULLISH" : "BEARISH",
            riskLevel: "MEDIUM",
            imageData: nil
        )
    }
} 