//
//  OnboardingView.swift
//  Graph AI
//
//  Created by Imran Sayeed on 3/10/25.
//

import Charts
import SwiftUI
import SDWebImageSwiftUI

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
    @State private var step: Int = 0
    @State private var selectedOption: String? = nil
    @Binding var shouldShowView: Bool
    private let totalSteps = 9

    //MARK: - Content Data
    let chartBIData: [ProfitablityItem] = [
        ProfitablityItem(title: "Chart AI", month: "Month 1", value: 0),
        ProfitablityItem(title: "Trading Gurus", month: "Month 1", value: 0),
        ProfitablityItem(title: "Chart AI", month: "Month 2", value: 10),
        ProfitablityItem(title: "Trading Gurus", month: "Month 2", value: 8),
        ProfitablityItem(title: "Chart AI", month: "Month 3", value: 13),
        ProfitablityItem(title: "Trading Gurus", month: "Month 3", value: 16),
        ProfitablityItem(title: "Chart AI", month: "Month 4", value: 16),
        ProfitablityItem(title: "Trading Gurus", month: "Month 4", value: 13),
        ProfitablityItem(title: "Chart AI", month: "Month 5", value: 18),
        ProfitablityItem(title: "Trading Gurus", month: "Month 5", value: 9),
        ProfitablityItem(title: "Chart AI", month: "Month 6", value: 20),
        ProfitablityItem(title: "Trading Gurus", month: "Month 6", value: 0),
    ]
    private let content: [ContentItem] = [
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
                "Based on Chart AI's historical data, profits are usually delayed at first, but after just 7 days, users typically see significant gains."
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
            title: "Chart AI Was Made for People Like You",
            subtitle: "+1000 Chart AI People", options: nil,
            showGraph: false, description: nil
        ),
        ContentItem(
            title:
                "Find High-Quality Setups 5X Faster With Chart AI vs on Your Own.",
            subtitle: "Chart AI makes it fast, easy, and expert-level precise.",
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
                "Chart AI Creates Long-Term Trading Success",
            subtitle: nil, options: nil,
            showGraph: false, description: nil
        ),
        ContentItem(
            title: "We're setting up your personalized AI chart assistant.",
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
            if step == 7 {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Your Profitability")
                        .font(.title)
                        .foregroundColor(.white)
                    VStack(alignment: .leading,spacing: 3) {
                        HStack {
                            Circle()
                                .fill(Color.blue)  // Legend color (default is automatic)
                                .frame(width: 6, height: 6)
                            Text("Chart AI")
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
                    .chartLegend(.hidden) // Moves legend to top
                    //                    .chartLegend {
                    //                        VStack(spacing: 3) {
                    //                            ForEach(
                    //                                ["Chart AI", "Trading Gurus"],
                    //                                id: \.self
                    //                            ) { title in
                    //                                HStack {
                    //                                    Circle()
                    //                                        .fill(Color.white)  // Legend color (default is automatic)
                    //                                        .frame(width: 10, height: 10)
                    //                                    Text(title)
                    //                                        .foregroundColor(.white)  // Change text to white
                    //                                }
                    //                            }
                    //                        }
                    //                    }

                    //                    .chartLegendSpacing(8)  // Adds spacing for better layout

                    Text(
                        "80% of Chart Al users achieve long-term profitability."
                    )
                    .font(.body)
                    .foregroundStyle(.gray.opacity(0.8))
                    .padding(.top, 8)
                }
                .frame(height: 300)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
            }

        }
    }

    func getConversationItemView() -> some View {
        LazyVStack(spacing: 10) {
            if step == 6, let items = content[step].commentItems {
                ForEach(items, id: \.id) { item in
                    LazyVStack(alignment: .leading, spacing: 8) {
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
                            Spacer()
                        }

                        Text(item.comment)
                            .foregroundColor(.white)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(minHeight: 120, maxHeight: .infinity)
                    }
                    //                    .frame(height: 140)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2)))
                }
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
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
                    .padding()

            }
            ProgressView(value: Double(step + 1), total: Double(totalSteps))
                .tint(.green)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
    }

    func titleAndSubTitleView() -> some View {
        LazyVStack(spacing: 10) {
            if step == 8 {
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
            if step == 6 {
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
            if step == 8 {
                AnimatedImage(name: "all_done.gif")
                               .resizable()
                               .scaledToFit()
                               .frame(width: 200, height: 200)
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
                            .frame(maxWidth: .infinity)
                            .padding(24)
                            .background(
                                selectedOption == option
                                    ? Color.white.opacity(0.9)
                                    : Color.gray.opacity(0.1)
                            )
                            .cornerRadius(10)

                    }
                }
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
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)

                //MARK: - Description Text
                if let description = content[step].description {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
    }

    func fourthScreenTradingView() -> some View {
        VStack {
            if step == 3 {
                VStack(spacing: 10) {
                    Spacer()
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
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                selectedOption == style.name
                                    ? Color.white
                                    : Color.gray.opacity(0.1)
                            )
                            .cornerRadius(15)
                        }
                    }
                    Spacer()
                }
            }
        }
    }

    func fifthScreenChartAIView() -> some View {
        LazyVStack {
            if step == 5 {
                LazyVStack(spacing: 10) {
                    LazyHStack(spacing: 10) {
                        // Without Chart AI
                        VStack {
                            Spacer()
                            Text("Without\nChart AI")
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

                        // With Chart AI
                        VStack {
                            Text("With\nChart AI")
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
                        "Chart AI makes it fast, easy, and expert-level precise."
                    )
                    .frame(height: 50)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(10)
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.vertical, 20)
            }
        }
    }

    //MARK: - Main UI Body
    var body: some View {
        VStack {
            // Progress Bar & Back Button
            topView()
            Spacer()
            ScrollView {
                // MARK: - Title & Subtitle
                if step < content.count {
                    VStack(alignment: .leading, spacing: 10) {
                        titleAndSubTitleView()
//                        Spacer()
                        // MARK: - List Items (For First Two Screens)
                        contentOptionListView()
//                        Spacer()
                        //MARK: - Show Graph (For Third Screen)
                        thirdScreenContentGraphView()

                        //MARK: - Trading Style Selection (For Fourth Screen)
                        fourthScreenTradingView()

                        //MARK: - Chart AI Step (Final Step)
                        fifthScreenChartAIView()

                        getConversationItemView()
                        profitabilityGraphView()
                    }
                    .padding()

                }
            }
            Spacer()

            //MARK: - Next Button
            Button(action: {
                withAnimation {
                    if step < content.count - 1 {
                        step += 1
                        selectedOption = nil
                    }
                }

            }) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(
                        (content[step].options == nil || selectedOption != nil)
                            ? Color.white : Color.white.opacity(0.5))

            }
            .background(
                (content[step].options == nil || selectedOption != nil)
                    ? Color.green : Color.green.opacity(0.5)
            )
            .cornerRadius(10)
            .padding()
            .disabled(content[step].options != nil && selectedOption == nil)
        }
        //        .animation(.easeInOut, value: step)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(shouldShowView: .constant(true))
    }
}
