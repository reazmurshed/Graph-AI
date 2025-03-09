import SwiftUI

struct MarketTrendAnimation: View {
    let isBullish: Bool
    @State private var pathProgress: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Background grid
            chartBackground
            
            // Main trend line
            trendLine
                .trim(from: 0, to: pathProgress)
                .stroke(isBullish ? Color.green : Color.red, style: StrokeStyle(
                    lineWidth: 3,
                    lineCap: .round,
                    lineJoin: .round
                ))
                .shadow(color: isBullish ? Color.green.opacity(0.5) : Color.red.opacity(0.5), radius: 4)
        }
        .frame(height: 120)
        .padding(.horizontal)
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                pathProgress = 1
            }
        }
    }
    
    private var chartBackground: some View {
        Path { path in
            // Draw grid lines
            for i in 0...4 {
                let y = CGFloat(i) * 30
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: 200, y: y))
            }
            for i in 0...8 {
                let x = CGFloat(i) * 25
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: 120))
            }
        }
        .stroke(Color.gray.opacity(0.2), style: StrokeStyle(
            lineWidth: 1,
            dash: [2, 2]
        ))
    }
    
    private var trendLine: Path {
        Path { path in
            let points = isBullish ? generateBullishPoints() : generateBearishPoints()
            path.move(to: points[0])
            
            for i in 1..<points.count {
                let control1 = CGPoint(
                    x: points[i-1].x + (points[i].x - points[i-1].x) / 3,
                    y: points[i-1].y
                )
                let control2 = CGPoint(
                    x: points[i].x - (points[i].x - points[i-1].x) / 3,
                    y: points[i].y
                )
                path.addCurve(
                    to: points[i],
                    control1: control1,
                    control2: control2
                )
            }
        }
    }
    
    private func generateBullishPoints() -> [CGPoint] {
        [
            CGPoint(x: 0, y: 100),
            CGPoint(x: 40, y: 80),
            CGPoint(x: 80, y: 60),
            CGPoint(x: 120, y: 30),
            CGPoint(x: 160, y: 20),
            CGPoint(x: 200, y: 10)
        ]
    }
    
    private func generateBearishPoints() -> [CGPoint] {
        [
            CGPoint(x: 0, y: 20),
            CGPoint(x: 40, y: 40),
            CGPoint(x: 80, y: 60),
            CGPoint(x: 120, y: 90),
            CGPoint(x: 160, y: 100),
            CGPoint(x: 200, y: 110)
        ]
    }
} 