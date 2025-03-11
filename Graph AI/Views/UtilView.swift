//
//  UtilView.swift
//  Graph AI
//
//  Created by Imran Sayeed on 3/11/25.
//
import SwiftUI
import Lottie

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0.0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0.4), Color.white.opacity(0.1), Color.white.opacity(0.4)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .blendMode(.overlay)
                .mask(content)
                .offset(x: phase)
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 200
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerEffect())
    }
}


// Insight Item View
struct InsightOptionItem: View {
    var icon: String
    var title: String
    var value: String
    var color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}

// Progress Indicator View
struct ProgressItem: View {
    var title: String
    var value: String
    var progress: CGFloat
    var color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 6)
                    .foregroundColor(Color.gray.opacity(0.3))
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 100 * progress, height: 6)
                    .foregroundColor(color)
            }
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}


// Detailed Analysis Section
struct DetailedAnalysisView: View {
    let analysisItems = [
        "Intraday Volatility",
        "Volume Spikes During Reversals",
        "Lack of Overarching Trend",
        "Dominance of Reversal Candles",
        "Support and Resistance"
    ]

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Detailed Analysis")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            ForEach(0..<analysisItems.count, id: \.self) { index in
                HStack {
                    NumberBadge(number: index + 1)
                    Text(analysisItems[index])
                        .foregroundColor(.white)
                        .font(.body)
                    Spacer()
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 6)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.3))
        .cornerRadius(12)
    }
}

// Number Badge View
struct NumberBadge: View {
    var number: Int

    var body: some View {
        Text("\(number)")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.green)
            .frame(width: 28, height: 28)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(6)
    }
}

// Lottie View Wrapper
struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
