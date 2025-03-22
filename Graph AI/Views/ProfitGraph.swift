//
//  ProfitGraph.swift
//  Graph AI
//
//  Created by Reaz Sumon on 22/3/25.
//

import SwiftUI
import Charts

struct CandlestickData: Identifiable {
    let id = UUID()
    let date: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
}

struct CandlestickChartView: View {
    let sampleData: [CandlestickData] = [
        CandlestickData(date: "", open: 100, high: 112, low: 106, close: 111),
        CandlestickData(date: "3 Days", open: 110, high: 115, low: 112, close: 112),
        CandlestickData(date: "7 Days", open: 112, high: 118, low: 108, close: 115),
        CandlestickData(date: "30 Days", open: 115, high: 120, low: 110, close: 119)
    ]
    
    var body: some View {
        Chart(sampleData) { candle in
            // High-Low line
            BarMark(
                x: .value("Date", candle.date),
                yStart: .value("Low", candle.low),
                yEnd: .value("High", candle.high)
            )
            .foregroundStyle(.gray)
            
            // Open-Close box (color-coded)
            RectangleMark(
                x: .value("Date", candle.date),
                yStart: .value("Open", candle.open),
                yEnd: .value("Close", candle.close)
            )
            .foregroundStyle(candle.open < candle.close ? .green : .red)
            .opacity(0.8)
        }
        .frame(height: 300)
        .padding()
    }
}

struct CandlestickChartView_Preview: View {
    var body: some View {
        CandlestickChartView()
    }
}

#Preview {
    CandlestickChartView_Preview()
}

