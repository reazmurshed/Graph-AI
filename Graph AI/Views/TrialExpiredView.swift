import SwiftUI

struct TrialExpiredView: View {
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "hourglass.bottomhalf.filled")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Trial Expired")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            Text("Subscribe to continue using the app")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            subscribeButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "1A1A1A"))
    }
    
    private var subscribeButton: some View {
        Button(action: {
            subscriptionManager.activateSubscription()
            dismiss()
        }) {
            Text("Subscribe Now")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.green)
                .cornerRadius(12)
        }
        .padding(.horizontal, 32)
        .padding(.top, 16)
    }
}

#Preview {
    ZStack {
        Color(hex: "1A1A1A")
        TrialExpiredView()
            .environmentObject(SubscriptionManager.preview)
    }
} 