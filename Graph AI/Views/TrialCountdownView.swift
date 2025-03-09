import SwiftUI

struct TrialCountdownView: View {
    let daysRemaining: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "clock")
                .foregroundColor(Constants.accentColor)
            
            Text("TRIAL_DAYS_REMAINING".localizedFormat(daysRemaining))
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.3))
        .cornerRadius(20)
    }
}

#Preview {
    ZStack {
        Color(hex: "1A1A1A")
        TrialCountdownView(daysRemaining: 2)
    }
} 