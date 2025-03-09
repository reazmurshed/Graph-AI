import Foundation
import UIKit
import AudioToolbox

// MARK: - Protocol
protocol APIClientProtocol {
    func analyzeGraph(_ imageData: Data) async throws -> GraphAnalysis
}

// MARK: - Implementation
final class APIClient: APIClientProtocol {
    static let shared = APIClient()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 120
        config.timeoutIntervalForResource = 120
        config.waitsForConnectivity = true
        config.requestCachePolicy = .returnCacheDataElseLoad
        
        self.session = URLSession(configuration: config)
        self.decoder = JSONDecoder()
    }
    
    func analyzeGraph(_ imageData: Data) async throws -> GraphAnalysis {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let base64Image = imageData.base64EncodedString()
        
        let requestBody: [String: Any] = buildAnalysisPrompt(for: imageData)
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        do {
            let (data, response) = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<(Data, URLResponse), Error>) in
                let task = self.session.dataTask(with: request) { [weak self] data, response, error in
                    if let error = error as? URLError, error.code == .timedOut {
                        Task { @MainActor in
                            await self?.showNotification(
                                message: "Servers are busy",
                                instruction: "Please try again in a moment"
                            )
                        }
                        continuation.resume(throwing: APIError.timeout)
                        return
                    }
                    
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    guard let data = data, let response = response else {
                        continuation.resume(throwing: APIError.invalidResponse)
                        return
                    }
                    
                    continuation.resume(returning: (data, response))
                }
                task.resume()
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                print("API Error Response: \(String(data: data, encoding: .utf8) ?? "No data")")
                throw APIError.serverError(statusCode: httpResponse.statusCode)
            }
            
            let openAIResponse = try decoder.decode(OpenAIResponse.self, from: data)
            return try parseOpenAIResponse(openAIResponse, imageData: imageData)
        } catch {
            print("API Error: \(error)")
            throw error
        }
    }
    
    private func buildAnalysisPrompt(for imageData: Data) -> [String: Any] {
        return [
            "model": "gpt-4o-mini",
            "messages": [
                [
                    "role": "system",
                    "content": """
                    You are a professional technical analyst specialized in chart analysis. 
                    Your task is to:
                    1. First, verify if the image is actually a financial chart/graph
                    2. If it's NOT a chart, respond with a witty dark humor joke about what you see instead
                    3. If it IS a chart but you can't analyze it properly, respond as not a chart
                    4. If it IS a chart and you can analyze it, provide a complete JSON response
                    
                    IMPORTANT: Provide ALL analysis in \(LanguageManager.shared.selectedLanguage.rawValue) language if the WHOLE analysis is not provided in \(LanguageManager.shared.selectedLanguage.rawValue) then its not valid.
                    IMPORTANT: Never return partial or "in progress" analysis. Either provide complete analysis or treat as not a chart.
                    
                    For valid charts, maintain this exact JSON structure:
                    {
                        "keyInsights": {
                            "trend": "Describe the trend in ONE word (e.g., BULLISH, BEARISH, NEUTRAL)",
                            "volatility": "Describe volatility in ONE word (e.g., EXPLOSIVE, CALM, CHOPPY)",
                            "volume": "Describe volume in ONE word (e.g., SURGING, WEAK, AVERAGE)",
                            "marketSentiment": "Describe sentiment in ONE word (e.g., FEARFUL, GREEDY, CAUTIOUS)",
                            "momentum": "Describe momentum in ONE word (e.g., STRONG, WEAK, FADING)",
                            "trendMaturity": "Describe maturity in ONE word (e.g., EARLY, MATURE, EXHAUSTED)"
                        },
                        "gamePlan": {
                            "narrative": "Write a brief, focused trading plan in a paragraph of 5 lines max. Include entry, stop loss, and target in natural "as spoken" language.",
                            "timeHorizon": "SHORT/LONG"
                        },
                        "technicalAnalysis": {
                            "trendAnalysis": {
                                "primary": "do not show Primary trend: make all in the same paragraph 2 lines paragraph trend description",
                                "strength": "combine all in the same paragraph 2 lines paragraph strength assessment"
                            },
                            "supportResistance": {
                                "supports": ["Price levels"],
                                "resistances": ["Price levels"]
                            },
                            "indicators": {
                                "rsi": "One short paragraph RSI status",
                                "macd": "One short paragraph MACD status",
                                "movingAverages": "One short paragraph MA status"
                            },
                            "volume": "One sentence volume assessment",
                            "patterns": ["Key patterns identified"]
                        }
                    }
                    
                    If NOT a chart, respond with:
                    {
                        "isChart": false,
                        "humorousComment": "Your dark humor observation"
                    }
                    
                    Guidelines:
                    - Be extremely concise
                    - Use single words for volatility and volume assessments
                    - Keep game plan to 2-3 sentences max
                    - Be precise with price levels
                    - Focus on actionable insights
                    IMPORTANT: Provide ALL analysis in \(LanguageManager.shared.selectedLanguage.rawValue) language if the WHOLE analysis is not provided in \(LanguageManager.shared.selectedLanguage.rawValue) then its not valid.
                    IMPORTANT: Never return partial or "in progress" analysis. Either provide complete analysis or treat as not a chart.
                    """
                ],
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": "Analyze this image and provide complete insights following the specified format. If you can't provide complete analysis, treat it as not a chart."
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpeg;base64,\(imageData.base64EncodedString())"
                            ]
                        ]
                    ]
                ]
            ],
            "max_tokens": 4000,
            "temperature": 0.7
        ]
    }
    
    private func parseOpenAIResponse(_ response: OpenAIResponse, imageData: Data) throws -> GraphAnalysis {
        guard let content = response.choices.first?.message.content else {
            throw APIError.decodingError
        }
        
        // Verificar si es un gráfico o no
        if let jsonData = content.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
            
            // Si la respuesta indica que no es un gráfico
            if let isChart = json["isChart"] as? Bool, !isChart {
                return GraphAnalysis.notAChart(
                    withHumor: json["humorousComment"] as? String ?? generateDarkHumor()
                )
            }
            
            // Procesar análisis normal del gráfico
            let keyInsights = json["keyInsights"] as? [String: String]
            let gamePlan = json["gamePlan"] as? [String: Any]
            let technicalAnalysis = json["technicalAnalysis"] as? [String: Any]
            
            // Extraer más información del análisis
            let trend = keyInsights?["trend"] ?? "NEUTRAL"
            let volume = keyInsights?["volume"] ?? "MEDIUM"
            let momentum = keyInsights?["momentum"] ?? "STABLE"
            let trendMaturity = keyInsights?["trendMaturity"] ?? "MIDDLE"
            
            let insights = [
                "Trend: \(trend)",
                "Volume: \(volume)",
                "Momentum: \(momentum)",
                "Trend Maturity: \(trendMaturity)"
            ]
            
            return GraphAnalysis(
                analysisText: content,
                data: GraphAnalysis.GraphData(
                    type: "Chart",
                    xAxis: "Time",
                    yAxis: "Value",
                    trend: trend,
                    insights: insights,
                    recommendations: extractRecommendations(from: gamePlan),
                    volume: volume
                ),
                isChart: true,
                humorousComment: nil,
                gamePlan: formatGamePlan(gamePlan),
                emoji: getTrendEmoji(trend),
                sentiment: keyInsights?["marketSentiment"] ?? "NEUTRAL",
                marketMood: keyInsights?["marketSentiment"] ?? "NEUTRAL",
                riskLevel: keyInsights?["volatility"] ?? "MEDIUM",
                imageData: imageData
            )
        }
        
        return GraphAnalysis.defaultAnalysis(with: content)
    }
    
    private func formatGamePlan(_ gamePlan: [String: Any]?) -> String {
        guard let plan = gamePlan,
              let narrative = plan["narrative"] as? String,
              let timeHorizon = plan["timeHorizon"] as? String else {
            return "No game plan available"
        }
        
        return """
        \(narrative)
        
        Time Horizon: \(timeHorizon)
        """
    }
    
    private func extractRecommendations(from gamePlan: [String: Any]?) -> [String] {
        var recommendations: [String] = []
        if let overview = gamePlan?["overview"] as? String {
            recommendations.append(overview)
        }
        if let entries = gamePlan?["entryPoints"] as? [[String: Any]] {
            recommendations.append(contentsOf: entries.compactMap { $0["condition"] as? String })
        }
        return recommendations
    }
    
    private func getTrendEmoji(_ trend: String) -> String {
        switch trend.lowercased() {
        case _ where trend.contains("bullish"): return "📈"
        case _ where trend.contains("bearish"): return "📉"
        default: return "📊"
        }
    }
    
    private func generateDarkHumor() -> String {
        let jokes = [
            "This looks as much like a chart as my portfolio looks profitable",
            "I've seen better patterns in my coffee stains",
            "If this is a chart, I'm Warren Buffett's financial advisor",
            "The only trend I see here is downward... like my trading career",
            "This makes about as much sense as buying high and selling low",
            "I'd have better luck analyzing my cat's whiskers for market signals",
            "Even my failed trades make more sense than this",
            "This is to charts what a pizza is to technical analysis",
            "My losing streak has better structure than this",
            "404: Chart not found, but I found your next bad investment"
        ]
        return jokes.randomElement() ?? "Even AI has standards... this isn't a chart"
    }
    
    @MainActor
    private func showNotification(message: String, instruction: String? = nil) {
        let banner = UIView()
        banner.backgroundColor = UIColor(white: 0.1, alpha: 0.95)
        banner.layer.cornerRadius = 15
        banner.clipsToBounds = true
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        
        stackView.addArrangedSubview(label)
        
        if let instruction = instruction {
            let instructionLabel = UILabel()
            instructionLabel.text = instruction
            instructionLabel.textColor = .gray
            instructionLabel.font = .systemFont(ofSize: 14, weight: .regular)
            instructionLabel.textAlignment = .center
            stackView.addArrangedSubview(instructionLabel)
        }
        
        banner.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: banner.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(equalTo: banner.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: banner.bottomAnchor, constant: -20)
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
        
        AudioServicesPlaySystemSound(1519)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
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
}

// MARK: - Errors
enum APIError: Error {
    case invalidResponse
    case decodingError
    case networkError
    case unauthorized
    case serverError(statusCode: Int)
    case timeout
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
} 
