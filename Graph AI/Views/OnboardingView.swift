//
//  OnboardingView.swift
//  Graph AI
//
//  Created by Imran Sayeed on 3/10/25.
//

import Charts
import SDWebImageSwiftUI
import SwiftUI
import AVFoundation
import Shimmer

struct ProfitData: Identifiable {
    let id = UUID()
    let day: String
    let value: Double
}

struct TradingStyle: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
}

struct ConversationItem: Identifiable {
    let id = UUID()
    let comment: String
    let userName: String
    let rating: Int
    let iconName: String
}

struct ContentItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let options: [String]?
    let showGraph: Bool
    let description: String?
    let commentItems: [ConversationItem]?

    init(
        title: String, subtitle: String?, options: [String]?, showGraph: Bool,
        description: String?, commentItems: [ConversationItem]? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.options = options
        self.showGraph = showGraph
        self.description = description
        self.commentItems = commentItems
    }
}

struct ProfitablityItem: Identifiable {
    let id = UUID()
    let title: String
    let month: String
    let value: Int
}

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var step: Int = 0
    @State private var selectedOption: String? = nil
    @Binding var shouldShowView: Bool
    @State var showingSubscriptionPromo: Bool

    private let totalSteps = 13
    var player: AVPlayer {
        if let url = Bundle.main.url(forResource: "ORIGINAL", withExtension: "mp4") {
            let player = AVPlayer(url: url)
            player.actionAtItemEnd = .none
            
            // Looping logic: Observe when the video finishes and restart
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: player.currentItem,
                queue: .main
            ) { _ in
                //playingVideo = false
                player.seek(to: .zero)
                player.play()
            }
            print("found video URL")
            player.play()
            return player
        } else {
            print("Can't find video URL")
        }
        
        return AVPlayer()
    }

    //MARK: - Content Data
    let chartBIData: [ProfitablityItem] = [
        ProfitablityItem(title: "Graph AI", month: "Month 1", value: 0),
        ProfitablityItem(title: "Trading Gurus", month: "Month 1", value: 0),
        ProfitablityItem(title: "Graph AI", month: "Month 2", value: 10),
        ProfitablityItem(title: "Trading Gurus", month: "Month 2", value: 8),
        ProfitablityItem(title: "Graph AI", month: "Month 3", value: 13),
        ProfitablityItem(title: "Trading Gurus", month: "Month 3", value: 16),
        ProfitablityItem(title: "Graph AI", month: "Month 4", value: 16),
        ProfitablityItem(title: "Trading Gurus", month: "Month 4", value: 13),
        ProfitablityItem(title: "Graph AI", month: "Month 5", value: 18),
        ProfitablityItem(title: "Trading Gurus", month: "Month 5", value: 9),
        ProfitablityItem(title: "Graph AI", month: "Month 6", value: 20),
        ProfitablityItem(title: "Trading Gurus", month: "Month 6", value: 0),
    ]
    private let content: [ContentItem] = [
        ContentItem(
            title: "Find Winning Trades with a Photo.",
            subtitle: nil,
            options: nil,
            showGraph: false,
            description: nil
        ),
        ContentItem(
            title: "Which market do you focus on?",
            subtitle: "This will be used to customize your chart analysis.",
            options: ["Stocks", "Crypto", "Futures", "Forex"],
            showGraph: false,
            description: nil
        ),
        ContentItem(
            title: "How much risk are you comfortable with?",
            subtitle: "This will be used to customize your chart analysis.",
            options: ["Low", "Medium", "High"], showGraph: false,
            description: nil
        ),
        ContentItem(
            title:
                "You're Just a Few Steps Away From Turning Charts Into Cash.",
            subtitle: "Your Profit Growth", options: nil, showGraph: true,
            description:
                "Based on Graph AI's historical data, profits are usually delayed at first, but after just 7 days, users typically see significant gains."
        ),
        ContentItem(
            title: "What's Your Trading Style?",
            subtitle: "This will be used to customize your chart analysis.",
            options: nil,
            showGraph: false, description: nil
        ),
        ContentItem(
            title: "How In-Depth Should We Analyze Your Charts?",
            subtitle: "This will be used to customize your chart analysis.",
            options: ["Simple", "Medium", "Deep Dive"], showGraph: false,
            description: nil
        ),
        ContentItem(
            title: "Graph AI Was Made for People Like You",
            subtitle: "+1000 Graph AI People", options: nil,
            showGraph: false, description: nil
        ),
        ContentItem(
            title:
                "Find High-Quality Setups 5X Faster With Graph AI vs on Your Own.",
            subtitle: "Graph AI makes it fast, easy, and expert-level precise.",
            options: nil,
            showGraph: false, description: nil,
            commentItems: [
                ConversationItem(
                    comment:
                        "Trading felt like gambling before. Now, I have a plan for every chart, and I'm seeing real, steady growth over time. Game Changer",
                    userName: "Chris M.", rating: 5, iconName: "profile_1"),
                ConversationItem(
                    comment:
                        "This App helped me spot setups I would've completely missed on my own. It's like having an expert guide every time I trade.",
                    userName: "Emily S.", rating: 5, iconName: "profile_2"),
                ConversationItem(
                    comment:
                        "It's not just about winning a trade here and there, it's about being profitable long-term. Chart Al finally helped me get there.",
                    userName: "Alex P.", rating: 5, iconName: "profile_3"),
            ]
        ),
        ContentItem(
            title:
                "Graph AI Creates Long-Term Trading Success",
            subtitle: nil, options: nil,
            showGraph: false, description: nil
        ),
        ContentItem(
            title: "We're setting up your personalized Graph AI assistant.",
            subtitle: nil,
            options: nil,
            showGraph: false,
            description: nil
        ),
        ContentItem(
            title: "Your Custom Graph AI Assistant is Ready!",
            subtitle:
                "Let's run your first chart analysis to see how it works.You can create custom scans later!",
            options: nil,
            showGraph: false,
            description: nil
        ),
        ContentItem(
            title: "Your Custom Graph AI Assistant is Ready!",
            subtitle: nil,
            options: nil,
            showGraph: false,
            description: nil
        ),
        ContentItem(
            title: "First Custom Graph AI Analysis!",
            subtitle: nil,
            options: nil,
            showGraph: false,
            description: nil
        ),
        ContentItem(
            title: "You're now ready to turn your charts into cash!",
            subtitle: nil,
            options: nil,
            showGraph: false,
            description: nil
        ),
    ]

    private let profitData: [ProfitData] = [
        ProfitData(day: "3 Days", value: 10),
        ProfitData(day: "7 Days", value: 30),
        ProfitData(day: "30 Days", value: 80),
    ]

    private let tradingStyles: [TradingStyle] = [
        TradingStyle(
            name: "Scalping", description: "Holding positions for seconds",
            icon: "🐇"),
        TradingStyle(
            name: "Day Trading", description: "Holding positions for hours",
            icon: "🐢"),
        TradingStyle(
            name: "Swing Trading",
            description: "Holding positions for days to weeks", icon: "🐌"),
    ]
    // MARK: - UI Components
    func profitabilityGraphView() -> some View {
        LazyVStack {
            if step == 8 {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Your Profitability")
                        .font(.title)
                        .foregroundColor(.white)
                    VStack(alignment: .leading, spacing: 3) {
                        HStack {
                            Circle()
                                .fill(Color.blue)  // Legend color (default is automatic)
                                .frame(width: 6, height: 6)
                            Text("Graph AI")
                                .foregroundColor(.white)  // Change text to white
                                .font(.headline)
                        }

                        HStack {
                            Circle()
                                .fill(Color.green)  // Legend color (default is automatic)
                                .frame(width: 6, height: 6)
                            Text("Trading Gurus")
                                .foregroundColor(.white)  // Change text to white
                                .font(.headline)
                        }
                    }

                    Chart {
                        ForEach(chartBIData, id: \.id) { data in
                            LineMark(
                                x: .value("Month", data.month),
                                y: .value("Profitability", data.value)
                            )
                            .foregroundStyle(by: .value("title", data.title))

                        }
                    }
                    .chartXAxis {
                        AxisMarks {
                            AxisGridLine()
                                .foregroundStyle(.white.opacity(0.5))  // Optional grid line color
                            AxisTick()
                                .foregroundStyle(.white)
                            AxisValueLabel()
                                .foregroundStyle(.white)
                        }
                    }
                    .chartYAxis {
                        AxisMarks {
                            AxisValueLabel()
                                .foregroundStyle(.white)
                        }
                    }
                    .foregroundColor(.white)
                    .chartLegend(.hidden)  // Moves legend to top

                    Text(
                        "80% of Chart Al users achieve long-term profitability."
                    )
                    .font(.body)
                    .foregroundStyle(.gray.opacity(0.8))
                    .padding(.top, 8)
                }
                .frame(height: 300)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(12)
            }

        }
    }

    func getConversationItemView() -> some View {
        LazyVStack(spacing: 10) {
            if step == 7, let items = content[step].commentItems {
                ForEach(items, id: \.id) { item in
                    LazyVStack(alignment: .leading, spacing: 4) {
                        LazyHStack(alignment: .center, spacing: 8) {
                            Image(item.iconName)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())

                            Text(item.userName)
                                .font(.subheadline)
                                .foregroundColor(.white)

                            LazyHStack(spacing: 2) {
                                ForEach(0..<item.rating, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.green)
                                }
                            }
//                            Spacer()
                        }

                        Text(item.comment)
                            .foregroundColor(.white)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(minHeight: 120, maxHeight: .infinity)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.4)))
                }
            } else {
                singleEmptyView()
            }

        }

    }

    func topView() -> some View {
        HStack {
            Button(action: {
                shouldShowView.toggle()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .padding(10)
                    .foregroundStyle(.white)
                    .background(Color.gray.opacity(0.4))
                    .clipShape(Circle())
                    .padding()

            }
            if step < 8 {
                ProgressView(value: Double(step + 1), total: Double(totalSteps))
                    .tint(.green)
                    .frame(maxWidth: .infinity)
            } else {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
    func twelveStepView() -> some View {
        ZStack {
            if step == 13 {
                LottieView(name: "confetti", loopMode: .loop)
                    .frame(width: 300, height: 300, alignment: .center)
            }
        }
        
    }

    func titleAndSubTitleView() -> some View {
        LazyVStack(spacing: 10) {
            if step == 9 || step == 13 {
                Spacer()
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.green)
                    Text("All done!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            Text(content[step].title)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            if step == 7 {
                LazyHStack(spacing: -10) {
                    ForEach(0..<3) { index in
                        Image("profile_\(index+1)")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                }.padding(.top, 20)
            }
            if let subtitle = content[step].subtitle {
                Text(subtitle)
                    .font(.title3)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            if step == 9 {
                Spacer()
                AnimatedImage(name: "all_done.gif")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .background(Color.clear)
            }
        }.padding(.horizontal, 16)
    }

    func contentOptionListView() -> some View {
        LazyVStack {
            if let options = content[step].options {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selectedOption = option
                    }) {
                        Text(option)
                            .font(.title2)
                            .bold()
                            .foregroundColor(
                                selectedOption == option
                                    ? Color.black : Color.white
                            )
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .padding(24)
                            .background(
                                selectedOption == option
                                    ? Color.white.opacity(0.9)
                                    : Color.gray.opacity(0.4)
                            )
                            .cornerRadius(20)
                    }
                }
            } else {
                EmptyView().frame(maxWidth: .infinity, maxHeight: 1)
            }
        }
    }

    func thirdScreenContentGraphView() -> some View {
        LazyVStack {
            if content[step].showGraph {
                Chart {
                    // Gradient Fill Under the Line
                    AreaMark(
                        x: .value("Day", profitData[0].day),
                        yStart: .value("Zero", 0),
                        yEnd: .value("Profit", profitData[0].value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green.opacity(0.5),
                                Color.clear,
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))

                    // Line Graph
                    ForEach(profitData) { data in
                        LineMark(
                            x: .value("Day", data.day),
                            y: .value("Profit", data.value)
                        )
                        .foregroundStyle(.green)

                        PointMark(
                            x: .value("Day", data.day),
                            y: .value("Profit", data.value)
                        )
                        .foregroundStyle(.green)
                    }
                }
                .frame(height: 200)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(12)

                //MARK: - Description Text
                if let description = content[step].description {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding()
                }
            } else {
                singleEmptyView()
            }
        }
    }

    func fourthScreenTradingView() -> some View {
        VStack {
            if step == 4 {
                VStack(spacing: 10) {
                    ForEach(tradingStyles) { style in
                        Button(action: {
                            selectedOption = style.name
                        }) {
                            HStack {
                                Text(style.icon)
                                    .font(.title2)
                                VStack(alignment: .leading) {
                                    Text(style.name)
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(
                                            selectedOption
                                                == style.name
                                                ? Color.black
                                                    .opacity(0.7)
                                                : Color.white
                                                    .opacity(0.7))
                                    Text(style.description)
                                        .font(.subheadline)
                                        .foregroundColor(
                                            selectedOption
                                                == style.name
                                                ? Color.black
                                                    .opacity(0.7)
                                                : Color.white
                                                    .opacity(0.7))
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                selectedOption == style.name
                                    ? Color.white
                                    : Color.gray.opacity(0.4)
                            )
                            .cornerRadius(15)
                        }
                    }
                }
            } else {
                singleEmptyView()
            }
        }
    }
    
    func singleEmptyView(height: CGFloat = 1) -> some View {
        EmptyView().frame(maxWidth: .infinity, maxHeight: height)
    }

    func fifthScreenChartAIView() -> some View {
        LazyVStack {
            if step == 6 {
                LazyVStack(spacing: 10) {
                    LazyHStack(spacing: 10) {
                        // Without Graph AI
                        VStack {
                            Spacer()
                            Text("Without\nGraph AI")
                                .font(.caption)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.8))
                                //                                        .frame(width: 90)
                                .overlay(
                                    Text("20%")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                )
                                .frame(height: 70)
                        }
                        .frame(width: 90)
                        .background(Color.black.opacity(0.9))
                        .cornerRadius(12)

                        // With Graph AI
                        VStack {
                            Text("With\nGraph AI")
                                .font(.caption)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.top, 10)
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green)
                                .overlay(
                                    Text("5X")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                        .bold()
                                )
                        }
                        .frame(width: 90)
                        .background(Color.black.opacity(0.9))
                        .cornerRadius(12)

                    }
                    .frame(height: 190)
                    .padding()

                    Text(
                        "Graph AI makes it fast, easy, and expert-level precise."
                    )
                    .frame(height: 50)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(10)
                }
                .background(Color.gray.opacity(0.4))
                .cornerRadius(12)
                .padding(.vertical, 20)
            } else {
                singleEmptyView()
            }
        }
    }

    func tenthScreenContentShimmerView() -> some View {
        VStack {
            if step == 11 {
                Image("analyzed_icon")  // Replace with actual image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [.purple, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing), lineWidth: 6)
                    )
                    .padding()

                VStack(spacing: 10) {
                    ForEach(0..<3) { _ in
                        PlaceholderCardView()
                    }
                    /*
                    AnimatedImage(name: "placeholder.gif")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 120)
                        .background(Color.clear)
                    */
                }
                .padding(.horizontal)

                Spacer()
            } else {
                singleEmptyView()
            }
        }
    }

    func ninthStepView() -> some View {
        HStack(alignment: .center) {
            if step == 10 {
                Spacer()
                Image("analyzed_icon")  // Replace with actual image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
            } else {
                singleEmptyView()
            }
        }
    }

    func eleventhStepView() -> some View {
        VStack(spacing: 16) {
            if step == 12 {
                // Key Insights Card
                VStack(alignment: .center, spacing: 12) {
                    Text("Key Insights")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    HStack {
                        InsightOptionItem(
                            icon: "chart.line.uptrend.xyaxis", title: "Trend",
                            value: "Bullish", color: .green)
                        Spacer()
                        InsightOptionItem(
                            icon: "chart.bar.doc.horizontal",
                            title: "Volatility", value: "Medium", color: .orange
                        )
                    }

                    HStack {
                        ProgressItem(
                            title: "Volume", value: "High", progress: 0.7,
                            color: .pink)
                        Spacer()
                        ProgressItem(
                            title: "Market Sentiment", value: "Neutral",
                            progress: 0.4, color: .gray)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(12)

                // Game Plan Card
                VStack(alignment: .center, spacing: 8) {
                    Text("Game Plan")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Text(
                        "Bitcoin is currently priced at around **$98,218** and showing strong bullish momentum with high volume, indicating growing interest. My trading plan is to enter a long position near **$97,500**, place a stop-loss just below the recent support at **$95,000**, and aim for a target of **$105,000**, which lines up with previous resistance levels."
                    )
                    .font(.body)
                    .foregroundColor(.gray)
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(12)
                
                DetailedAnalysisView()

                Spacer()
            } else {
                singleEmptyView()
            }
        }
    }
    
    func initialVideoView() -> some View {
        VStack {
            if step == 0 {
                
                // Permium Features Section
                HStack(alignment: .bottom) {
                    VideoPlayerView(player: player)
                        .onAppear {
                            player.play()
                        }
                        .onDisappear {
                            player.pause()
                        }
                        .frame(height: 500, alignment: .bottom)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                }
            } else {
                singleEmptyView()
            }
        }
    }

    //MARK: - Main UI Body
    var body: some View {
        VStack {
            // Progress Bar & Back Button
            if step > 0 {
                topView()
            } else {
//                Spacer()
            }
//            Spacer()
            ScrollView() {
                // MARK: - Title & Subtitle
                if step < content.count {
                    VStack(alignment: .leading, spacing: 6) {
                        ZStack {
                            titleAndSubTitleView()
                            twelveStepView()
                        }
                        initialVideoView()

                        // MARK: - List Items (For First Two Screens)
                        contentOptionListView().padding(.horizontal, 15)
                        //MARK: - Show Graph (For Third Screen)
                        thirdScreenContentGraphView().padding(.horizontal, 15)

                        //MARK: - Trading Style Selection (For Fourth Screen)
                        fourthScreenTradingView().padding(.horizontal, 15)

                        //MARK: - Graph AI Step (Final Step)
                        fifthScreenChartAIView().padding(.horizontal, 15)

                        getConversationItemView().padding(.horizontal, 15)
                        profitabilityGraphView().padding(.horizontal, 15)
                        ninthStepView().padding(.horizontal, 15)
                        tenthScreenContentShimmerView().padding(.horizontal, 15)
                        eleventhStepView().padding(.horizontal, 15)
                    }
                    .frame(maxHeight: .infinity)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 5)
                }
            }

            //MARK: - Next Button
            Button(action: {
                withAnimation {
                    player.pause()
                    if step == 13 {
                        UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.alreadyOnboarded)
                        shouldShowView.toggle()
                    }
                    if step < content.count - 1 {
                        step += 1
                        selectedOption = nil
                    }
                    if step == 9 || step == 11 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                            if step < content.count - 1 {
                                step += 1
                                selectedOption = nil
                            }
                        }
                    }
                    
                }

            }) {
                if step == 9 {
                    customizedText("Analyze Chart")
                } else if step == 13 {
                    customizedText("Get Started")
                } else {
                    customizedText("Next")
                }
            }
            .background(
                (content[step].options == nil || selectedOption != nil)
                    ? Color.green : Color.green.opacity(0.5)
            )
            .cornerRadius(20)
            .padding()
            .disabled(content[step].options != nil && selectedOption == nil)
            .opacity((step == 9 || step == 11) ? 0 : 1)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    func customizedText(_ text: String) -> some View {
        Text(text)
            .frame(maxWidth: .infinity, maxHeight: 80)
            .cornerRadius(20)
            .foregroundColor(
                (content[step].options == nil || selectedOption != nil)
                    ? Color.white : Color.white.opacity(0.5))
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(shouldShowView: .constant(true), showingSubscriptionPromo: true)
    }
}
