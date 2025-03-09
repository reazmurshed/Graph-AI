import SwiftUI
import Foundation

struct WaitingView: View {
    let image: UIImage
    let analysis: GraphAnalysis?
    @State private var selectedEmojis: [String] = []
    @State private var emojiOffsets: [CGFloat] = [-20, 0, 20]
    @State private var currentFact = 0
    
    private let financeEmojis = ["💰", "📈", "💎", "🚀", "🌕", "🐂", "🐻", "💵", "🎰", "🎲", "🔥", "💫"]
    
    private let cryptoFacts = [
        "Bitcoin's creator is still HODLing in their mom's basement... probably",
        "NFTs: Because paying rent is overrated when you can own a digital monkey",
        "Proof of Work: Converting electricity into digital disappointment since 2009",
        "DYOR usually means 'watching YouTube while eating ramen'",
        "Diamond hands? More like anxiety hands, am I right?",
        "To the moon! 🚀 (Terms and conditions may apply)",
        "Buy high, sell low - A strategy so bad it might just work",
        "Crypto winter is just spicy HODL season",
        "Your seed phrase is shorter than your ex's list of red flags",
        "51% attack? That's still better odds than my dating life",
        "Smart contracts are like relationships - expensive to deploy, costly to maintain",
        "DeFi: Because traditional banking wasn't complicated enough",
        "Staking: The art of getting paid to do nothing (finally!)",
        "Gas fees are like taxes, but with more crying",
        "Web3: Like Web2 but with more wallets to forget passwords for",
        "Decentralized: When no one knows who to blame",
        "ICO: Internet Confetti Offering",
        "Alt season is like Christmas, but Santa is a meme coin",
        "Not your keys, not your crypto, not your lambo",
        "FUD: When your portfolio is down but your memes are up"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Empty space at top (10% down)
                Spacer()
                    .frame(height: geometry.size.height * 0.1)
                
                // Title
                Text("Analyzing Chart...")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(.white)
                
                // Space between title and image (20%)
                Spacer()
                    .frame(height: geometry.size.height * 0.2)
                
                // Image with negative offset (7% up)
                Image(uiImage: image)
                    .chartImageStyle()
                    .padding(.horizontal)
                    .offset(y: -geometry.size.height * 0.07)
                
                Spacer()
                
                // Emojis
                HStack(spacing: 30) {
                    ForEach(0..<3) { index in
                        Text(selectedEmojis.count > index ? selectedEmojis[index] : "")
                            .font(.system(size: 40))
                            .offset(y: emojiOffsets[index])
                            .scaleEffect(1.0 + sin(Double(index) * .pi / 2) * 0.2)
                    }
                }
                .frame(height: 60)
                
                // Space between emojis and fact (5%)
                Spacer()
                    .frame(height: geometry.size.height * 0.05)
                
                // Fact text (5% up from bottom)
                Text(cryptoFacts[currentFact])
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.bottom, geometry.size.height * 0.05)
                    .transition(.opacity)
                    .id(currentFact)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "1A1A1A"))
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        func updateEmojis() {
            selectedEmojis = Array(financeEmojis.shuffled().prefix(3))
            
            // Animaciones más complejas para los emojis
            for i in 0..<3 {
                withAnimation(
                    Animation
                        .easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.2)
                ) {
                    emojiOffsets[i] = CGFloat.random(in: -20...20)
                }
            }
        }
        
        updateEmojis()
        
        // Cambiar emojis y sus animaciones cada 8 segundos
        Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { _ in
            updateEmojis()
        }
        
        // Cambiar fact cada 4 segundos
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            withAnimation {
                currentFact = (currentFact + 1) % cryptoFacts.count
            }
        }
    }
}

#Preview {
    WaitingView(image: UIImage(), analysis: nil)
} 