//
//  OnboardingView.swift
//  Graph AI
//
//  Created by Imran Sayeed on 3/10/25.
//

import Charts
import SwiftUI

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

struct ContentItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let options: [String]?
    let showGraph: Bool
    let description: String?
}

struct OnboardingView: View {
    @State private var step: Int = 0
    @State private var selectedOption: String? = nil
    @Binding var shouldShowView: Bool
    private let totalSteps = 6
    
    //MARK: - Content Data
    private let content:
    [ContentItem] = [
        ContentItem(
            title:"Which market do you focus on?",
            subtitle: "This will be used to customize your chart analysis.",
            options:["Stocks", "Crypto", "Futures", "Forex"],
            showGraph: false,
            description: nil
        ),
        ContentItem(
            title:"How much risk are you comfortable with?",
            subtitle:"This will be used to customize your chart analysis.",
            options:["Low", "Medium", "High"], showGraph:false, description:nil
            ),
        ContentItem(
                title:"You're Just a Few Steps Away From Turning Charts Into Cash.",
                subtitle:"Your Profit Growth", options:nil, showGraph:true,
                description:"Based on Chart AI's historical data, profits are usually delayed at first, but after just 7 days, users typically see significant gains."
            ),
        ContentItem(
            title:"What's Your Trading Style?",
            subtitle:"This will be used to customize your chart analysis.", options: nil,
            showGraph:false, description:nil
            ),
        ContentItem(
            title:"How In-Depth Should We Analyze Your Charts?",
            subtitle:"This will be used to customize your chart analysis.",
            options:["Simple", "Medium", "Deep Dive"], showGraph:false, description:nil
            ),
        ContentItem(
            title:"Find High-Quality Setups 5X Faster With Chart AI vs on Your Own.",
            subtitle:"Chart AI makes it fast, easy, and expert-level precise.", options:nil,
            showGraph:false, description:nil
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

    var body: some View {
        VStack {
            // Progress Bar & Back Button
            HStack {
//                if step > 0 {
//                    Button(action: {
//                        if step > 0 {
//                            step -= 1
//                            selectedOption = nil
//                        }
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .font(.title2)
//                            .padding()
//                    }
//                }
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
            Spacer()
            ScrollView {
                // MARK: - Title & Subtitle
                if step < content.count {
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(spacing: 10) {
                            Text(content[step].title)
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            if let subtitle = content[step].subtitle {
                                Text(subtitle)
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }.padding(.horizontal, 16)
                        Spacer()
                        // MARK: - List Items (For First Two Screens)
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
                        Spacer()
                        //MARK: - Show Graph (For Third Screen)
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
                                            Color.green.opacity(0.5), Color.clear,
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

                        //MARK: - Trading Style Selection (For Fourth Screen)
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
                                                    .foregroundColor(selectedOption == style.name
                                                                     ? Color.black.opacity(0.7)
                                                                     : Color.white.opacity(0.7))
                                                Text(style.description)
                                                    .font(.subheadline)
                                                    .foregroundColor(selectedOption == style.name
                                                                     ? Color.black.opacity(0.7)
                                                                     : Color.white.opacity(0.7))
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

                        //MARK: - Chart AI Step (Final Step)
                        if step == 5 {
                            VStack(spacing: 10) {
                                HStack(spacing: 10) {
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
                                            .frame(height:70)
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
                                            .padding(.top,10)
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
                                .frame(height:50)
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
                    .padding()

                }
            }
            Spacer()

            //MARK: - Next Button
            Button(action: {
                if step < content.count - 1 {
                    step += 1
                    selectedOption = nil
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
        .animation(.easeInOut, value: step)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(shouldShowView: .constant(true))
    }
}
