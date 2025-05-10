import SwiftUI

struct SubscriptionPromoView: View {
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingPaywallIntro = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(hex: "0A2342")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated stars background effect
            StarsView()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Logo and header
                    VStack(spacing: 20) {
                        Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                Circle()
                                    .fill(Color.blue.opacity(0.3))
                                    .frame(width: 150, height: 150)
                            )
                        
                        Text("Upgrade to Graph AI Premium")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Unlock the full potential of chart analysis")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 40)
                    
                    // Premium benefits
                    VStack(spacing: 25) {
                        PremiumFeature(
                            icon: "infinity",
                            title: "Unlimited Analysis",
                            description: "Analyze all the charts you need without restrictions"
                        )
                        
                        PremiumFeature(
                            icon: "brain",
                            title: "Advanced AI",
                            description: "Access our most sophisticated analysis algorithms"
                        )
                        
                        PremiumFeature(
                            icon: "icloud",
                            title: "Cloud Sync",
                            description: "Save and access your analysis from any device"
                        )
                        
                        PremiumFeature(
                            icon: "bell.badge",
                            title: "Custom Alerts",
                            description: "Get notified when your conditions are met"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Action buttons
                    VStack(spacing: 15) {
                        Button(action: {
                            showingPaywallIntro = PaywallHelper.shared.isSubscribed
                            //dismiss()
                            //subscriptionManager.activateSubscription()
                        }) {
                            Text("Subscribe Now")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        
                        Button("Not Now") {
                            dismiss()
                        }
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 5)
                    }
                    .padding(.vertical, 20)
                }
                .padding(.bottom, 30)
            }
            
            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white.opacity(0.7))
                            .padding()
                    }
                }
                Spacer()
            }
        }.fullScreenCover(isPresented: $showingPaywallIntro) {
            PaywallView()
        }
    }
}

// Premium Feature Component
struct PremiumFeature: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.blue)
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.15))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.07))
        )
    }
}

// Animated stars for background
struct StarsView: View {
    let starCount = 50
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<starCount, id: \.self) { index in
                Star(
                    position: randomPosition(in: geometry.size),
                    size: CGFloat.random(in: 1...3),
                    opacity: Double.random(in: 0.2...0.8),
                    animationDuration: Double.random(in: 1.5...3.5)
                )
            }
        }
    }
    
    private func randomPosition(in size: CGSize) -> CGPoint {
        CGPoint(
            x: CGFloat.random(in: 0...size.width),
            y: CGFloat.random(in: 0...size.height)
        )
    }
}

struct Star: View {
    let position: CGPoint
    let size: CGFloat
    let opacity: Double
    let animationDuration: Double
    
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: size, height: size)
            .position(position)
            .opacity(isAnimating ? opacity : opacity/3)
            .scaleEffect(isAnimating ? 1 : 0.5)
            .onAppear {
                withAnimation(
                    Animation
                        .easeInOut(duration: animationDuration)
                        .repeatForever(autoreverses: true)
                ) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    SubscriptionPromoView()
        .environmentObject(SubscriptionManager.preview)
} 
